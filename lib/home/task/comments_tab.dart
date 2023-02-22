import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mintness/providers/comments_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';
import '../../style.dart';

class CommentsTab extends StatefulWidget {
  final TaskProvider taskProvider;

  CommentsTab(this.taskProvider);

  @override
  State createState() => new CommentsTabState();
}

class CommentsTabState extends State<CommentsTab>
    with TickerProviderStateMixin, FullscreenLoaderMixin<CommentsTab> {
  bool _timerCancel = false;
  FocusNode _commentsFocusNode = FocusNode();
  final TextEditingController _commentController = new TextEditingController();
  CommentsProvider _commentsProvider;
  var tappedComment;
  final ScrollController _scrollController = ScrollController();
  bool _emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    _commentController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length));
  }
  _onBackspacePressed() {
    _commentController
      ..text = _commentController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length));
    Navigator.pop(context);
  }


  void _initProvider() async {
    _commentsProvider = context.read<CommentsProvider>();
    await _commentsProvider.init(widget.taskProvider?.task?.task?.id);
    loadNewComments(_commentsProvider);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initProvider);
  }

  void loadNewComments(CommentsProvider commentsProvider) async {
    Timer.periodic(Duration(seconds: 3), (timer) {
      loadAllComments(commentsProvider);
      if (_timerCancel) timer.cancel();
    });
  }

  void loadAllComments(CommentsProvider commentsProvider) async {
    await commentsProvider.loadComments(widget.taskProvider?.task?.task?.id);
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    onBack();
    super.dispose();
  }

  Future<bool> onBack() {
    _timerCancel = true;
    _commentsProvider?.reset();
    Navigator.pop(context);
    return Future.value(false);
  }

  Widget build(BuildContext context) {
    return Consumer<CommentsProvider>(
        builder: (_, CommentsProvider commentsProvider, __) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.backgroundPageBody,
          body: commentsProvider?.isInited
              ? Stack(
                  children: [
                    WillPopScope(
                      onWillPop: () => _onBackspacePressed(),
                      child: Stack(children: [
                        _commentList(commentsProvider),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_emojiShowing) buildSticker(),
                                Row(
                                  children: _filesPanel(commentsProvider),
                                ),
                                _commentTextField(),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    if (showLoader) const FullscreenLoader()
                  ],
                )
              : Container()

          //new
          );
    });
  }


  Widget buildSticker() {
    return Offstage(
      offstage: !_emojiShowing,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
            onEmojiSelected: (Category category, Emoji emoji) {
              _onEmojiSelected(emoji);
            },
            onBackspacePressed: _onBackspacePressed,
            config: Config(
                columns: 7,
                // Issue: https://github.com/flutter/flutter/issues/28894
                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecentsText: 'No Recents',
                noRecentsStyle:
                    const TextStyle(fontSize: 20, color: Colors.black26),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL)),
      ),
    );
  }

  Widget _commentList(CommentsProvider commentsProvider) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemCount: commentsProvider.comments.length,
          itemBuilder: (_, int index) {
            return Container(
              padding: EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: commentsProvider.comments[index]
                              ['user_id'] ==
                          profileProvider.userId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.end,
                  children: [
                    commentsProvider.comments[index]['user_id'] ==
                            profileProvider.userId
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.8,
                                decoration: BoxDecoration(
                                  color: AppColor.backgroundChatMessage,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 10, top: 5, right: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SvgPicture.asset(
                                            'lib/assets/icons/check_read.svg',
                                            width: 12.75,
                                            height: 6,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                              '${DateFormat.jm().format(DateFormat("hh:mm").parse(commentsProvider.comments[index]['created_at'].split(' ')[1]))}',
                                              style:
                                                  AppTextStyle.commentTimeItem),
                                          SizedBox(width: 5),
                                          Text('You',
                                              style: AppTextStyle
                                                  .commentAuthorItem),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                            child: GestureDetector(
                                                child: Container(
                                          child: Text(
                                              '${commentsProvider.comments[index]['text'] ?? ''}',
                                              style:
                                                  AppTextStyle.commentTextItem),
                                          //padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(left: 10),
                                        )))
                                      ],
                                    ),
                                    if (commentsProvider
                                            .comments[index]['files'].length >
                                        0)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              _commentAttachments(
                                                  context,
                                                  commentsProvider
                                                      .comments[index],
                                                  profileProvider),
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              avatar(
                                  commentsProvider.comments[index]['user']
                                      ['avatar'],
                                  null,
                                  commentsProvider.comments[index]['user']
                                      ['name']),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(218, 218, 218, 1)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${commentsProvider.comments[index]['user']['name']}',
                                              style: AppTextStyle
                                                  .commentAuthorItem),
                                          SizedBox(width: 10),
                                          Text(
                                              '${DateFormat.jm().format(DateFormat("hh:mm").parse(commentsProvider.comments[index]['created_at'].split(' ')[1]))}',
                                              style:
                                                  AppTextStyle.commentTimeItem),
                                          SizedBox(width: 10),
                                          SvgPicture.asset(
                                            'lib/assets/icons/check_read.svg',
                                            width: 12.75,
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          '${commentsProvider.comments[index]['text'] ?? ''} ',
                                          style: AppTextStyle.commentTextItem,
                                        ),
                                      ),
                                      if (commentsProvider
                                              .comments[index]['files'].length >
                                          0)
                                        _commentAttachments(
                                            context,
                                            commentsProvider.comments[index],
                                            profileProvider)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                  ]),
            );
          },
        ),
      );
    });
  }

  Widget _commentAttachments(BuildContext context, Map<String, dynamic> comment,
      ProfileProvider profileProvider) {
    final size = (MediaQuery.of(context).size.width - 126) / 3.0;
    return Row(
      mainAxisAlignment: comment['user_id'] == profileProvider.userId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        for (int i = 0; i < comment['files'].length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Stack(children: [
            comment['files'][i]['thumbnail_link']!=null?  ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                height: size,
                width: size,
                //color: AppColor.divider,
                child:  CachedNetworkImage(
                  imageUrl: comment['files'][i]['thumbnail_link'],
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => const SizedBox(),
                ) ,
              ),
            ):Container(),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      color: Color.fromRGBO(117, 130, 139, 0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/check_read.svg',
                          width: 12.75,
                          height: 6,
                        ),
                        SizedBox(width: 5),
                        Container(
                          child: Text(
                            '${comment['created_at'].split(' ')[1]} ${comment['created_at'].split(' ')[2]}',
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ],
      ],
    );
  }

  Widget _commentTextField() {
    return Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
      return Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  focusNode: _commentsFocusNode,
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  onSubmitted:  (_) {
                    if(_commentsProvider.isEmptyComment(_commentController.text.trim())) return;
                     _commentsProvider.sendComment(
                        commentText: _commentController.text,
                        taskId: taskProvider.task.task.id);
                    _commentController.clear();
                    _commentsFocusNode.unfocus();
                    _emojiShowing = false;
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 80,
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        return _commentsProvider.chooseCommentFiles();
                      },
                      child: SvgPicture.asset(
                        'lib/assets/icons/chat_select_file.svg',
                        width: 22.4,
                        height: 23.8,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        return _commentsProvider.chooseCommentImages();
                      },
                      child: SvgPicture.asset(
                        'lib/assets/icons/chat_select_image.svg',
                        width: 23.1,
                        height: 23.1,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _emojiShowing = !_emojiShowing;
                        });
                      },
                      child: SvgPicture.asset(
                        'lib/assets/icons/chat_select_emojii.svg',
                        width: 25.2,
                        height: 25.2,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => runWithLoader(() async {
                        if(_commentsProvider.isEmptyComment(_commentController.text.trim())) return;
                        await _commentsProvider.sendComment(
                            commentText: _commentController.text,
                            taskId: taskProvider.task.task.id);
                        _commentController.clear();
                        _commentsFocusNode.unfocus();
                        _emojiShowing = false;
                      }),
                      child: SvgPicture.asset(
                        'lib/assets/icons/sent_active.svg',
                        width: 25.2,
                        height: 25.2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _imagesPanel(CommentsProvider commentsProvider) {
    return commentsProvider.chosenCommentImages
        .map((image) => InkWell(
      onTap:()=> setState(() {
        commentsProvider.chosenCommentImages.remove(image);
      }) ,
          child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Icon(
                  Icons.image,
                  color: AppColor.primary,
                ),
              ),
        ))
        .toList()
        .cast<Widget>();
  }

  List<Widget> _mediaPanel(CommentsProvider commentsProvider) {
    return commentsProvider.chosenCommentFiles
        .map((image) => InkWell(
              onTap:()=> setState(() {
                commentsProvider.chosenCommentFiles.remove(image);
              }) ,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Image.file(File(image.path))
              ),
            ))
        .toList()
        .cast<Widget>();
  }

  List<Widget> _filesPanel(CommentsProvider commentsProvider) {
    return [
      ..._imagesPanel(commentsProvider),
      ..._mediaPanel(commentsProvider)
    ];
  }

//07/29/2021 12:02:44 -> 2021-07-29
  DateTime translateFormat(String dateTime) {
    String date = dateTime.split(' ')[0];
    String y = date.split('/')[2];
    String m = date.split('/')[0];
    String d = date.split('/')[1];
    return DateFormat.yMd('en_US').parse('$m/$d/$y');
  }
}

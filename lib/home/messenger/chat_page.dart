import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mintness/home/messenger/controllers/socket_controller.dart';
import 'package:mintness/home/messenger/user_info_page.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/accept_decline_dialog.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';

class ChatMessengerPage extends StatefulWidget {
  final int conversationId;

  const ChatMessengerPage({Key key, this.conversationId}) : super(key: key);

  @override
  _ChatMessengerPageState createState() => _ChatMessengerPageState();
}

class _ChatMessengerPageState extends State<ChatMessengerPage>
    with FullscreenLoaderMixin<ChatMessengerPage> {
  TextEditingController _commentController = TextEditingController();

  bool _isTextFieldHasContentYet;

  bool _emojiShowing = false;
  GlobalKey _keyChatItem = GlobalKey();

  var _commentsFocusNode = FocusNode();

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, const ProfilePage());
  }

  void _navigateToUserPage(int userId) {
    NavigationService()
        .push(context, Direction.fromRight, UserInfoPage(userId));
  }

  @override
  void initState() {
    _commentController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
      context.read<MessengerProvider>().socketController =
          SocketController.get(context);

      // _commentController.addListener(() {
      //   final _text = _commentController.text.trim();
      //   if (_text.isEmpty) {
      //     _socketController.stopTyping();
      //     _isTextFieldHasContentYet = false;
      //   } else {
      //     if (_isTextFieldHasContentYet) return;
      //     _socketController.typing();
      //     _isTextFieldHasContentYet = true;
      //   }
      // });

      setState(() {});
    });
    _getComments();
    super.initState();
  }

  _getComments() {
    runWithLoader(() async {
      await context
          .read<MessengerProvider>()
          .loadComments(widget.conversationId);
    });
  }

  @override
  void dispose() {
    context.read<MessengerProvider>().socketController.unsubscribe();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Consumer<MessengerProvider>(
          builder: (_, MessengerProvider messangerProvider, __) {
        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: AppColor.backgroundPageBody,
              title: Consumer<ProfileProvider>(
                  builder: (_, ProfileProvider profileProvider, __) {
                return _header(profileProvider);
              })),
          backgroundColor: AppColor.backgroundPageBody,
          body: _body(messangerProvider),
        );
      }),
      if (showLoader) const FullscreenLoader(),
    ]);
  }

  Widget _body(MessengerProvider messengerProvider) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            _commentList(messengerProvider),
          ],
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_emojiShowing) buildSticker(),
              Row(
                children: _filesPanel(messengerProvider),
              ),
              if (messengerProvider.isEditMessage) ...[
                _buildEdit(messengerProvider)
              ] else if (messengerProvider.isReply) ...[
                _buildReply(messengerProvider)
              ],
              _messageField(messengerProvider),
            ],
          ))
    ]);
  }

  Widget _buildEdit(MessengerProvider messengerProvider) {
    _commentController.text = messengerProvider.editedMessageContent;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.edit),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edit Message'),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Text(
                              '${messengerProvider.editedMessageContent}')),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () {
                  // messengerProvider.editedMessageContent = null;
                  // messengerProvider.editedMessageId = null;
                  // messengerProvider.isEditMessage = false;
                  // _commentController.text = '';

                  messengerProvider.isEditMessage = false;
                  messengerProvider.isReply = false;
                },
                child: Icon(Icons.clear))
          ],
        ),
      ),
    );
  }

  Widget _buildReply(MessengerProvider messengerProvider) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.edit),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${messengerProvider.repliedUserName}'),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Text('${messengerProvider.repliedMessage}')),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () {
                  // messengerProvider.repliedMessageId = null;
                  // messengerProvider.repliedUserName = null;
                  // messengerProvider.isReply = false;
                  // _commentController.text = '';
                  messengerProvider.isEditMessage = false;
                  messengerProvider.isReply = false;
                  // messengerProvider.repliedUserName = null;
                  // messengerProvider.isReply = false;
                  // _commentController.text = '';
                },
                child: Icon(Icons.clear))
          ],
        ),
      ),
    );
  }

  List<Widget> _imagesPanel(MessengerProvider messengerProvider) {
    return messengerProvider.chosenCommentImages
        .map((image) => InkWell(
              onTap: () => setState(() {
                messengerProvider.chosenCommentImages.remove(image);
              }),
              child: const Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Icon(
                    Icons.image,
                    size: 50,
                  )),
            ))
        .toList()
        .cast<Widget>();
  }

  List<Widget> _mediaPanel(MessengerProvider messengerProvider) {
    return messengerProvider.chosenCommentFiles
        .map((file) => InkWell(
              onTap: () => setState(() {
                messengerProvider.chosenCommentFiles.remove(file);
              }),
              child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Icon(
                    Icons.file_copy_outlined,
                    size: 50,
                  )),
            ))
        .toList()
        .cast<Widget>();
  }

  List<Widget> _filesPanel(MessengerProvider messengerProvider) {
    return [
      ..._imagesPanel(messengerProvider),
      ..._mediaPanel(messengerProvider)
    ];
  }

  _onBackspacePressed() {
    _commentController
      ..text = _commentController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length));
    Navigator.pop(context);
  }

  _onEmojiSelected(Emoji emoji) {
    _commentController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length));
  }

  _getSize() {
    final RenderBox renderBoxRed =
        _keyChatItem.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    print("SIZE of _keyChatItem: $size");
  }

  _afterLayout(_) {
    _getSize();
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

  Widget _commentList(MessengerProvider messengerProvider) {
    return Expanded(
      child: Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView.builder(
            //controller: _scrollController,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: messengerProvider?.comments?.length ?? 0,
            itemBuilder: (_, int index) {
              return Container(
                padding: EdgeInsets.all(5),
                child: Column(
                    crossAxisAlignment: messengerProvider.comments[index]
                                ['user_id'] ==
                            profileProvider.userId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.end,
                    children: [
                      if (messengerProvider.comments[index]['user_id'] ==
                          profileProvider.userId)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: const BoxDecoration(
                                color: AppColor.backgroundChatMessage,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 10, top: 5, right: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/icons/check_read.svg',
                                          width: 12.75,
                                          height: 6,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                            '${DateFormat.jm().format(DateFormat("hh:mm").parse(messengerProvider.comments[index]['created_at'].split(' ')[1]))}',
                                            style:
                                                AppTextStyle.commentTimeItem),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                          child: GestureDetector(
                                              child: Container(
                                        child: Row(
                                          children: [
                                            if (messengerProvider
                                                        .comments[index]
                                                    ['reply_id'] !=
                                                null) ...[
                                              Container(
                                                width: 3,
                                                height: 20,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                            Expanded(
                                              child: Text(
                                                  '${messengerProvider.comments[index]['content'] ?? ''}',
                                                  style: AppTextStyle
                                                      .commentTextItem),
                                            ),
                                          ],
                                        ),
                                      )))
                                    ],
                                  ),
                                  if (messengerProvider.comments[index]
                                          ['reply_id'] !=
                                      null)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                '${messengerProvider.comments[index]['reply_message']['content']}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  if (messengerProvider
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
                                                messengerProvider
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
                        ),
                      if (messengerProvider.comments[index]['user_id'] !=
                          profileProvider.userId)
                        Row(
                          //key: _keyChatItem,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<HomeProvider>(
                                builder: (_, HomeProvider homeProvider, __) {
                              return avatar(
                                homeProvider.users.firstWhere((user) =>
                                    user['id'] ==
                                    messengerProvider.comments[index]
                                        ['user_id'])['avatar'],
                                () => _navigateToUserPage(messengerProvider
                                    .comments[index]['user_id']),
                                homeProvider.users.firstWhere((user) =>
                                    user['id'] ==
                                    messengerProvider.comments[index]
                                        ['user_id'])['name'],
                              );
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(218, 218, 218, 1)),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (messengerProvider.comments[index]
                                                ['reply_id'] !=
                                            null) ...[
                                          Container(
                                            width: 3,
                                            height: 20,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                        Consumer<HomeProvider>(builder:
                                            (_, HomeProvider homeProvider, __) {
                                          return Text(
                                              '${homeProvider.users.firstWhere((user) => user['id'] == messengerProvider.comments[index]['user_id'])['name']}',
                                              style: AppTextStyle
                                                  .commentAuthorItem);
                                        }),
                                        SizedBox(width: 10),
                                        Text(
                                            '${DateFormat.jm().format(DateFormat("hh:mm").parse(messengerProvider.comments[index]['created_at'].split(' ')[1]))}',
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
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        '${messengerProvider.comments[index]['content'] ?? ''} ',
                                        style: AppTextStyle.commentTextItem,
                                      ),
                                    ),
                                    if (messengerProvider
                                            .comments[index]['files'].length >
                                        0)
                                      _commentAttachments(
                                          context,
                                          messengerProvider.comments[index],
                                          profileProvider)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: _popupCommentMenu(
                                  messengerProvider.comments[index]),
                            )
                          ],
                        ),
                    ]),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _popupCommentMenu(Map<String, dynamic> comment) =>
      Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return Consumer<MessengerProvider>(
            builder: (_, MessengerProvider messengerProvider, __) {
          return Consumer<HomeProvider>(
              builder: (_, HomeProvider homeProvider, __) {
            return PopupMenuButton<int>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Reply"),
                  ),
                  const PopupMenuDivider(
                    height: 10,
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Edit"),
                  ),
                  const PopupMenuDivider(
                    height: 10,
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("Delete"),
                  ),
                ];
                return null;
              },
              onSelected: (value) {
                if (value == 1) {
                  messengerProvider.isReply = true;
                  messengerProvider.repliedMessageId = comment['id'];
                  messengerProvider.repliedMessage = comment['content'];
                  messengerProvider.repliedUserName = homeProvider.users
                      .firstWhere(
                          (user) => user['id'] == comment['user_id'])['name'];
                } else if (value == 2) {
                  messengerProvider.editedMessageId = comment['id'];
                  messengerProvider.editedMessageContent = comment['content'];
                  messengerProvider.isEditMessage = true;
                } else if (value == 3) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AcceptDeclineAlertDialog(
                        () {
                          Navigator.pop(context);
                          runWithLoader(() async {
                            await messengerProvider
                                .deleteComment(comment['id']);
                          });
                        },
                        "Delete Message",
                        "Are you sure? Once deleted, this message cannot be recovered.",
                      );
                    },
                  );
                }
              },
              child: Container(
                height: 35,
                width: 35,
                child: SvgPicture.asset(
                  'lib/assets/icons/more.svg',
                ),
              ),
            );
          });
        });
      });

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
            comment['files'][i]['thumbnail_link'] != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: size,
                      width: size,
                      //color: AppColor.divider,
                      child: CachedNetworkImage(
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
                      ),
                    ),
                  )
                : Container(),
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

  Widget _header(ProfileProvider profileProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            backButton(context),
            avatar(profileProvider.avatarUrl, _navigateToProfilePage,
                profileProvider.fullName),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profileProvider.fullName}',
                  style: AppTextStyle.listTileTitle,
                ),
                Text(
                  profileProvider.lastSeen ?? '',
                  style: AppTextStyle.listTileSubtitle,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'lib/assets/icons/sluhavka.svg',
            ),
            const SizedBox(width: 20.0),
            SvgPicture.asset(
              'lib/assets/icons/video.svg',
            ),
          ],
        )
      ],
    );
  }

  _processMessage(MessengerProvider messengerProvider) async {
    if (messengerProvider.isEditMessage) {
      await messengerProvider.updateComment(
          files: messengerProvider.chosenCommentFiles,
          message: _commentController.text.trim(),
          messageId: messengerProvider.editedMessageId,
          pinned: 0);
    } else if (messengerProvider.isReply) {
      await messengerProvider.replyComment(
          conversationId: widget.conversationId,
          content: _commentController.text.trim(),
          messageId: messengerProvider.repliedMessageId);
    } else {
      await messengerProvider.sendComment(
          conversationId: widget.conversationId,
          message: _commentController.text.trim(),
          files: messengerProvider.chosenCommentFiles);
    }

    setState(() {
      _commentController.clear();
      _commentsFocusNode.unfocus();
      _emojiShowing = false;
    });
  }

  Widget _messageField(MessengerProvider messengerProvider) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                maxLines: null,
                focusNode: _commentsFocusNode,
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                // onTap: (){
                //   _commentController.selection =
                //       TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                //   print('_commentController.selection  ${_commentController.selection }');
                // },
                onChanged: (text) =>
                    messengerProvider.messageFromController = text,
                onSubmitted: (_) {
                  if (messengerProvider
                      .isEmptyComment(_commentController.text.trim())) return;
                  runWithLoader(() async {
                    await _processMessage(messengerProvider);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 5, left: 5),
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    return messengerProvider.chooseCommentFiles();
                  },
                  child: SvgPicture.asset(
                    'lib/assets/icons/chat_select_file.svg',
                    width: 20,
                    height: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    messengerProvider.chooseCommentImages(context);
                  },
                  child: SvgPicture.asset(
                    'lib/assets/icons/chat_select_image.svg',
                    width: 20,
                    height: 20,
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
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    runWithLoader(() async {
                      _processMessage(messengerProvider);
                    });
                  },
                  child: SvgPicture.asset(
                    'lib/assets/icons/sent_active.svg',
                    width: 22.2,
                    height: 22.2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

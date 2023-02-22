import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mintness/home/messenger/controllers/socket_controller.dart';
import 'package:mintness/home/messenger/user_info_page.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/other_widgets.dart';

import '../../style.dart';

class ChatMessageIem extends StatefulWidget {
  final int index;

  const ChatMessageIem({Key key, this.index}) : super(key: key);

  @override
  State<ChatMessageIem> createState() => _ChatMessageIemState();
}

class _ChatMessageIemState extends State<ChatMessageIem> {
  void _navigateToUserPage(int userId) {
    NavigationService()
        .push(context, Direction.fromRight, UserInfoPage(userId));
  }

  Widget commentAttachments(
    BuildContext context,
    Map<String, dynamic> comment,
  ) {
    final size = (MediaQuery.of(context).size.width - 126) / 3.0;
  return  Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
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
                          errorWidget: (context, url, error) =>
                              const SizedBox(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (ctx, constraints) {
        return Consumer<MessengerProvider>(
            builder: (_, MessengerProvider messengerProvider, __) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<HomeProvider>(builder: (_, HomeProvider homeProvider, __) {
                return avatar(
                  homeProvider.users.firstWhere((user) =>
                      user['id'] ==
                      messengerProvider.comments[widget.index]
                          ['user_id'])['avatar'],
                  () => _navigateToUserPage(
                      messengerProvider.comments[widget.index]['user_id']),
                  homeProvider.users.firstWhere((user) =>
                      user['id'] ==
                      messengerProvider.comments[widget.index]
                          ['user_id'])['name'],
                );
              }),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: Color.fromRGBO(218, 218, 218, 1)),
                    borderRadius: BorderRadius.only(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Consumer<HomeProvider>(
                              builder: (_, HomeProvider homeProvider, __) {
                            return Text(
                                '${homeProvider.users.firstWhere((user) => user['id'] == messengerProvider.comments[widget.index]['user_id'])['name']}',
                                style: AppTextStyle.commentAuthorItem);
                          }),
                          SizedBox(width: 10),
                          Text(
                              '${DateFormat.jm().format(DateFormat("hh:mm").parse(messengerProvider.comments[widget.index]['created_at'].split(' ')[1]))}',
                              style: AppTextStyle.commentTimeItem),
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
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          '${messengerProvider.comments[widget.index]['content'] ?? ''} ',
                          style: AppTextStyle.commentTextItem,
                        ),
                      ),
                      if (messengerProvider
                              .comments[widget.index]['files'].length >
                          0)
                        commentAttachments(
                          context,
                          messengerProvider.comments[widget.index],
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                  height: constraints.maxHeight / 2,
                  child: Center(
                      child: SvgPicture.asset('lib/assets/icons/more.svg')))
            ],
          );
        });
      }),
    );
  }
}

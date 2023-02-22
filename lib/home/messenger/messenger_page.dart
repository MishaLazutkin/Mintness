import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/home/messenger/controllers/socket_controller.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/widgets/search_widget.dart';
import 'package:mintness/home/messenger/create_channel.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/custom_bottom_bar.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';
import '../../style.dart';
import 'chat_page.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({Key key}) : super(key: key);

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage>
    with FullscreenLoaderMixin<MessengerPage>, TickerProviderStateMixin {
  String searchedText = '';

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, const ProfilePage());
  }

  void _navigateToCreateChannelPage() {
    NavigationService().push(context, Direction.fromRight, const CreateChannelPage());
  }


  void _initProvider() {
    final profileProvider = context.read<ProfileProvider>();
    final messengerProvider = context.read<MessengerProvider>();
    runWithLoader(()  async {
      await  Future.wait([profileProvider.init(), messengerProvider.init()]);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initProvider);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      SocketController.get(context)
        ..init()
        ..connect(
          onConnectionError: (data) {
            print('onConnectionError ${data}');
          },
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final timeTrackerProvider = Provider.of<TimeTrackerProvider>(context);
    return Stack(
      children: [
        Consumer<MessengerProvider>(
          builder: (_, MessengerProvider provider, __) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor:timeTrackerProvider.currentTimer != null
                    ?timeTrackerProvider.timerData.headerColor: AppColor.backgroundPageHeader,
                title: _header(profileProvider,timeTrackerProvider),
              ),
              backgroundColor: AppColor.backgroundPageBody,
              body: _body(provider,timeTrackerProvider),
              bottomNavigationBar: CustomBottomBar(4),
            );
          },
        ),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }


  Widget _header(ProfileProvider profileProvider,TimeTrackerProvider timeTrackerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        avatar(profileProvider.avatarUrl, _navigateToProfilePage,
            profileProvider.fullName),
        timeTrackerProvider.currentTimer != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/assets/icons/timer.svg',
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
          '${timeTrackerProvider.timerData?.currentSession}',
          style: timeTrackerProvider.timerData.textStyle,
        ),
              ],
            )
            : Text(
          'Messenger',
          style: AppTextStyle.pageTitle,
        ),

        InkWell(
          onTap: _navigateToCreateChannelPage,
          child: SvgPicture.asset(
            'lib/assets/icons/write_outline_24.svg',
          ),
        ),
      ],
    );
  }

  Widget _body(MessengerProvider messengerProvider,TimeTrackerProvider timeTrackerProvider) {
    return Container(
      color: timeTrackerProvider.currentTimer != null
          ?timeTrackerProvider.timerData.headerColor:  AppColor.backgroundPageHeader,
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(child: _searchField(messengerProvider)),
            Divider(thickness: 1),
            _listConversations(messengerProvider)
          ],
        ),
        decoration: BoxDecoration(
          color: AppColor.backgroundPageBody,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        //height: 40,
      ),
    );
  }

  Future<void> _navigateToChatPage( int conversationId ) async {
    NavigationService().push(
      context,
      Direction.fromRight, ChatMessengerPage(conversationId:  conversationId ),
    );
  }

  Widget _listConversations(MessengerProvider messengerProvider) {
    return Consumer<HomeProvider>(builder: (_, HomeProvider homeProvider, __) {
      return Expanded(
        child: ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            separatorBuilder: (context, index) =>
                Divider(
                  height: 20,
                ),
            itemCount: messengerProvider?.conversations?.length ?? 0,
            itemBuilder: (context, index) {
              return InkWell(
                onTap:() => _navigateToChatPage(messengerProvider.conversations[index]['id']),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    if (messengerProvider.conversations[index]['last_message'] !=
                        null) ...[
                      avatar(messengerProvider.conversations[index]['avatar'], null,
                          messengerProvider.conversations[index]['name']),
                    ],
                    if (messengerProvider.conversations[index]['last_message'] ==
                        null) ...[
                      avatar(messengerProvider.conversations[index]['avatar'], null,
                          '${homeProvider?.users?.firstWhere((user) => (user['id'] == messengerProvider.conversations[index]['user_id']))['name']}${homeProvider?.users?.firstWhere((user) => (user['id'] == messengerProvider.conversations[index]['user_id']))['name'].toUpperCase()}'),
                    ],
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                          Text(
                            '${messengerProvider.conversations[index]['name']}',
                            style: AppTextStyle.listTileTitle,
                          ),

                          Row(
                            children: [
                              if (messengerProvider.conversations[index]['last_message']!=null&&
                              messengerProvider.conversations[index]['last_message']['type']!= 'text')

                               ...[ SvgPicture.asset(
                                'lib/assets/icons/file.svg',
                                width: 12.8,
                                height: 13.6,
                              ),
                              SizedBox(width: 5.6,),],
                              if (messengerProvider.conversations[index]['last_message']!=null)
                            ... [ SizedBox(
                              width: 200,
                                child: Text(
                                  '${messengerProvider.conversations[index]['last_message']['content']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.listTileSubtitleOpacity,
                                ),
                              ),]
                            ],
                          ),


                        ],

                    ),
                    Spacer(),
                    if (messengerProvider.conversations[index]['last_message'] != null)
                      Column(
                        children: [
                          Text(
                            '${messengerProvider.conversations[index]['last_message']['created_at'].split(' ')[1]}',
                            style: AppTextStyle.listTileSubtitleOpacity,
                          ),
                          if(messengerProvider.conversations[index]['last_message']["unread_messages_count"]!=null)
                          Container(
                            width: 30,
                            //height: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(child: Text('${messengerProvider.conversations[index]['last_message']["unread_messages_count"]}',
                                style: TextStyle(color: Colors.white,fontSize: 12),
                              ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color:  Color.fromRGBO(0, 36, 74, 1).withOpacity(0.5),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),)
                        ],
                      ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }

  Widget _searchField(MessengerProvider messengerProvider) {
    return SearchWidget(
      text: searchedText,
      onChanged: (text) => setState(() {
        messengerProvider.searchedText = text;
      }),
      hintText: 'Search ',
    );
  }
}

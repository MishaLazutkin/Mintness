import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mintness/home/messenger/chat_page.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../style.dart';

@immutable
class UserInfoPage extends StatefulWidget {
  final int userId;
  const UserInfoPage(   this.userId);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with FullscreenLoaderMixin<UserInfoPage> {

  _navigateToChat() {
    NavigationService().push(context, Direction.fromRight, const ChatMessengerPage());
  }

  void _initUserInfo() {
    final provider = context.read<MessengerProvider>();
    runWithLoader(() async {
      await provider.loadUserInfo(widget.userId);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initUserInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.backgroundPageBody,
          body: Container(child: _body()),
        ),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          _header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _userInfo(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _header() {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: backButton(context),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Back',
            style: AppTextStyle.pageTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<MessengerProvider>(
        builder: (_, MessengerProvider messangerProvider, __) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              avatar(messangerProvider.userInfo['avatar'],
                  _navigateToChat,messangerProvider.userInfo['name'], 100,100,25),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${messangerProvider.userInfo['name']??''}',
                    style: AppTextStyle.profileName,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${messangerProvider.userInfo['position']??''}',
                    style: AppTextStyle.profileItemTitle,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'last seen ${messangerProvider.userInfo['lastseen']??''}',
                    style: AppTextStyle.profileItemTitle,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 90),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    height: 50,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            IconData(
                              int.parse(
                                  '${messangerProvider.userInfo['status']['label'].substring(0,
                                      messangerProvider.userInfo['status']['label'].indexOf(' ')).toString().replaceFirst('&#', '0')}'),
                            ),
                            //size: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              '${messangerProvider.userInfo['status']['label'].toString().substring(
                                  messangerProvider.userInfo['status']['label'].indexOf(' '), messangerProvider.userInfo['status']['label'].length)}',
                              style: AppTextStyle.itemUserStatuses,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Until',
                      ),
                      Text(
                        '${messangerProvider.userInfo['until']??''}',
                        style: AppTextStyle.profileItemTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  _iconsPanel(),
                  const SizedBox(height: 24.0),
                  Column(
                    children: [
                      Text(
                        'Dob',
                      ),
                      const SizedBox(height: 7.0),
                      Text(
                        '${messangerProvider.userInfo['dob']??''}',
                        style: AppTextStyle.profileItemTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        'Local Time',
                      ),
                      const SizedBox(height: 7.0),
                      Text(
                        '${messangerProvider.userInfo['time_local']??''}',
                        style: AppTextStyle.profileItemTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        'Phone',
                      ),
                      const SizedBox(height: 7.0),
                      Text(
                        '${messangerProvider.userInfo['phone']??''}',
                        style: AppTextStyle.profileItemTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        'Mail',
                      ),
                      const SizedBox(height: 7.0),
                      Text(
                        '${messangerProvider.userInfo['email']??''}',
                        style: AppTextStyle.profileItemTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _iconsPanel() {
    return Column(
      children: [
        Divider(
          thickness: 1,
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/icons/telegram.svg',
            ),
            const SizedBox(width: 20.0),
            SvgPicture.asset(
              'lib/assets/icons/phone.svg',
            ),
            const SizedBox(width: 20.0),
            SvgPicture.asset(
              'lib/assets/icons/camera.svg',
            ),
          ],
        ),
        Divider(
          thickness: 1,
          height: 10,
        ),
      ],
    );
  }
}

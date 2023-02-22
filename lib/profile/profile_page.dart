import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mintness/profile/change_dob.dart';
import 'package:mintness/profile/statuses_dropdown_custom.dart';
import 'package:mintness/providers/auth_provider.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../style.dart';
import 'change_avatar.dart';
import 'change_password.dart';
import 'change_phone.dart';

@immutable
class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with FullscreenLoaderMixin<ProfilePage>, TickerProviderStateMixin  {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  AnimationController _scaleController;


  _navigateToChangePhone() {
    NavigationService().push(context, Direction.fromRight, const ChangePhone());
  }


   _navigateToChangeAvatar() {
    NavigationService().push(context, Direction.fromRight, const ChangeAvatarPage());
  }

   _navigateToChangePassword() {
    NavigationService().push(context, Direction.fromBottom, const ChangePassword());
  }


  Future<void> _logout() async {
    final successfulSignedOut = await runWithLoader(() async {
      return context.read<AuthProvider>().logout();
    });
    if (successfulSignedOut) {
      Future.delayed(
        const Duration(milliseconds: 300),
        context.read<HomeProvider>().reset,
      );
      context.read<TimeTrackerProvider>().resetTimer();

    }
  }

  void _initProvider() {
    final provider = context.read<ProfileProvider>();
    runWithLoader(() async {
      await provider.init();
    });
  }

  void _refreshProvider() async{
    final provider = context.read<ProfileProvider>();
    await provider.init();
    _refreshController.refreshCompleted();
  }



  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    Future.microtask(_initProvider);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.profileBackground,
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
            child: SmartRefresher(
              enablePullDown: true,
              header: CustomHeader(
                refreshStyle: RefreshStyle.Behind,
                onOffsetChange: (offset) {
                  if (_refreshController.headerMode.value != RefreshStatus.refreshing)
                    _scaleController.value = offset / 80.0;
                },
                builder: (c, m) {
                  return Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                    alignment: Alignment.center,
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _refreshProvider,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _userInfo(),
                    const SizedBox(height: 24),
                    _buttons(),
                  ],
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: backButton(context),
          ),
          Text(
            'Profile',
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
      child: Consumer<ProfileProvider>(
        builder: (_, ProfileProvider provider, __) {
          return Column(
            children: [
              const SizedBox(height: 16),
              avatar(provider.avatarUrl,_navigateToChangeAvatar,provider.fullName ?? '',100,100,25),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${provider.fullName ?? ''}',
                    style: AppTextStyle.profileName,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.position ?? '',
                    style: AppTextStyle.profileItemTitle,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    //margin: EdgeInsets.symmetric(horizontal: 90),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    height: 40,
                    child: Center(child: StatusesDropDownCustom())
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Until ${provider.lastSeen ?? ''}',
                    style: AppTextStyle.profileItemTitle,
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'DOB',
                            style: AppTextStyle.profileItemTitle,
                          ),
                          Text(
                            '${provider.dob}',
                            style: AppTextStyle.profileItemText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 1,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Phone',
                            style: AppTextStyle.profileItemTitle,
                          ),
                          Text(
                            provider.phone ?? '',
                            style: AppTextStyle.profileItemText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _navigateToChangePhone();
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'lib/assets/icons/edit.svg',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    ],
                  ),

                  Divider(
                    thickness: 1,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Mail',
                            style: AppTextStyle.profileItemTitle,
                          ),
                          Text(
                            '${provider.email}',
                            style: AppTextStyle.profileItemText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Consumer<AuthProvider>(
              builder: (BuildContext context, AuthProvider provider, _) {
            return Hero(
              tag: 'AuthSubmitButton',
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    text: 'Change Password',
                    isDisabled: false,
                    onTap: _navigateToChangePassword,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          Consumer<AuthProvider>(
              builder: (BuildContext context, AuthProvider provider, _) {
            return Hero(
              tag: 'AuthSubmitButton',
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    enabledColor: AppColor.buttonLogout,
                    text: 'Log out',
                    isDisabled: false,
                    onTap: () {
                      _logout();
                    },
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

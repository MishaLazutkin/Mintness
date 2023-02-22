import 'package:flutter/material.dart';
import 'package:mintness/home/addTask/add_task.dart';
import 'package:mintness/home/time_tracker/time_tracker_page.dart';
import 'package:mintness/home/home_page.dart';
import 'package:mintness/home/messenger/create_channel.dart';
import 'package:mintness/home/messenger/messenger_page.dart';
import 'package:mintness/home/messenger/user_info_page.dart';
import 'package:mintness/home/notifications/notifications_page.dart';
import 'package:mintness/home/time/time_page.dart';
import 'package:mintness/services/navigation_service.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style.dart';


@immutable
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  
  const CustomBottomBar(this.currentIndex);

  Direction getDirection(int index) {
    return index > currentIndex ? Direction.fromRight : Direction.fromLeft;
  }

  void _navigateTo(BuildContext context, int index, Widget page) {
    NavigationService().push(context, getDirection(index), page);
  }

  void _onTap(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0: page = const HomePage(); break;
      //case 1: page = const TimePage(); break;
      //case 2: page = const AddTaskPage(); break;
      case 2: page = const TimeTrackerPage(); break;
      //case 3: page = const NotificationsPage(); break;
      //case 4: page = const MessengerPage();
      case 4: page = const MessengerPage();
     // case 4: page = const CreateChannelPage();
        break;

      default: break;
    }
    if (page != null) {
      _navigateTo(
        context,
        index,
        WillPopScope(
          onWillPop: () async => true,
          child: page,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: CustomBottomBar,
      child: Material(
        child: Container(
          height: 49 + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: AppColor.backgroundPageBody,

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _button(context, 0, 'lib/assets/icons/project.svg'),
              _button(context, 1, 'lib/assets/icons/time.svg'),
              _button(context, 2, 'lib/assets/icons/timer.svg', true),
              _button(context, 3, 'lib/assets/icons/notifications.svg'),
              _button(context, 4, 'lib/assets/icons/messanger.svg'),

            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
    BuildContext context,
    int index,
    String iconPath, [
    bool showNotificationsCounter = false,
  ]) {
    final _isCurrent = index == currentIndex;
    return GestureDetector(
      onTap: _isCurrent ? null : () => _onTap(context, index),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width / 5,
        alignment: AlignmentDirectional.center,
        child: Stack(
          children: [
              SvgPicture.asset(
                    iconPath,
                    color: _isCurrent ? AppColor.primary : AppColor.secondary,
                  ),

            // if (showNotificationsCounter)
            //   Positioned(
            //     top: 8,
            //     right: 12,
            //     child: _notificationsCounter(),
            //   ),
          ],
        ),
      ),
    );
  }

//
  // Widget _notificationsCounter() {
  //   return Consumer<NotificationsProvider>(
  //     builder: (_, NotificationsProvider provider, __) {
  //       if ((provider.counter ?? 0) == 0) return const SizedBox();
  //       return Container(
  //         height: provider.counter > 9 ? 16 : 14,
  //         width: provider.counter > 9 ? 16 : 14,
  //         alignment: Alignment.center,
  //         padding: const EdgeInsets.only(bottom: 0.75, left: 0.66),
  //         decoration: BoxDecoration(
  //           color: AppColor.primary,
  //           borderRadius: BorderRadius.circular(provider.counter > 9 ? 8 : 7),
  //           border: Border.all(color: AppColor.white, width: 1),
  //         ),
  //         child: Text(
  //           provider.counter.toString(),
  //           style: AppTextStyle.notificationsCounter,
  //         ),
  //       );
  //     },
  //   );
  // }
}

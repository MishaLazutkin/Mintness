import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mintness/home/time_tracker/timetracker_projects_dropdown.dart';
import 'package:mintness/home/time_tracker/timetracker_tasks_dropdown.dart';
import 'package:mintness/home/receint_tasks/recent_tasks.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:provider/provider.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({Key key}) : super(key: key);

  @override
  _TimerTabState createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab>
    with SingleTickerProviderStateMixin, FullscreenLoaderMixin<TimerTab> {
  void _navigateToReceintTasksPage(int userId) {
    NavigationService()
        .push(context, Direction.fromBottom, RecentTasks(userId: userId));
  }

  @override
  void initState() {
    super.initState();
    TimeTrackerProvider timeTrackerProvider =
        context.read<TimeTrackerProvider>();
    timeTrackerProvider.ctrlDescription.text =
        context.read<TimeTrackerProvider>().timerData.description;
    _totalTime(timeTrackerProvider);
  }

  _totalTime(TimeTrackerProvider timeTrackerProvider) async {
    runWithLoader(() async {
      await timeTrackerProvider.loadTotalTimePerDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(child: SingleChildScrollView(child:
            Consumer<TimeTrackerProvider>(
                builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Current Session',
                    style: AppTextStyle.pageBodyItem,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${timeTrackerProvider.timerData?.currentSession ?? ''}',
                    style: TextStyle(fontSize: 48, color: AppColor.labelColor),
                  ),
                  SizedBox(
                      height: 25,
                      child: Divider(thickness: 1, color: HexColor('#DCDCDC'))),
                  Text(
                    'Today: ${timeTrackerProvider.totalTimePerDay}',
                    style: AppTextStyle.pageBodyItem,
                  ),
                  SizedBox(
                      height: 25,
                      child: Divider(thickness: 1, color: HexColor('#DCDCDC'))),
                  RichTextItem(
                    'Project',
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TimeTrackerProjectsDropDown(),
                  SizedBox(
                    height: 20,
                  ),
                  RichTextItem(
                    'Task',
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TimeTrackerTasksDropDown(),
                  SizedBox(
                    height: 20,
                  ),
                  RichTextItem(
                    'Description',
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 86),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.backgroundChatMessage,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: TextField(
                            onChanged: (value) =>
                                timeTrackerProvider.description = value,
                            readOnly: timeTrackerProvider.isDropDownsLocked
                                ? true
                                : false,
                            controller: timeTrackerProvider.ctrlDescription,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Aa...',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12)),
                          ))),
                  SizedBox(
                    height: 67,
                  ),
                  timeTrackerProvider.currentTimer != null
                      ? CustomButton(
                          text: 'Stop',
                          onTap: () {
                            runWithLoader(() async {
                              await timeTrackerProvider.stopTimer();
                              _totalTime(timeTrackerProvider);
                            });
                          },
                          leading: SvgPicture.asset(
                            'lib/assets/icons/stop.svg',
                            width: 14,
                            height: 13,
                          ),
                        )
                      : CustomButton(
                          text: 'Start',
                          isDisabled: timeTrackerProvider.validate() == false,
                          onTap: () {
                            runWithLoader(() async {
                              await timeTrackerProvider.startNewTimer(
                                  timeTrackerProvider.description);
                            });
                          },
                          leading: SvgPicture.asset(
                            'lib/assets/icons/play.svg',
                            width: 14,
                            height: 13,
                          ),
                        ),
                  Consumer<ProfileProvider>(
                      builder: (_, ProfileProvider profileProvider, __) {
                    return InkWell(
                      onTap: () =>
                          _navigateToReceintTasksPage(profileProvider.userId),
                      child: Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Recent Tasks',
                              style: AppTextStyle.subtaskItem,
                            )
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          );
        }))),
        if (showLoader) const FullscreenLoader(showGrayBackground: false),
      ],
    );
  }
}

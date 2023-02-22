import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/recent_task_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class RecentTasks extends StatefulWidget {
  const RecentTasks({Key key, this.userId}) : super(key: key);

  final int userId;
  @override
  _RecentTasksState createState() => _RecentTasksState();
}

class _RecentTasksState extends State<RecentTasks>
    with FullscreenLoaderMixin<RecentTasks> {
  RecentTaskProvider recentTasksProvider;

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, const ProfilePage());
  }

  void _initProvider() {
    recentTasksProvider = context.read<RecentTaskProvider>();
    runWithLoader(() async {
      await recentTasksProvider.init(widget.userId);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkPageBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColor.backgroundPageHeader,
          title: _pageHeader( ),
        ),
      ),
      body: Stack(
        children: [
          _body() ,
         // Container(height: double.infinity, color: AppColor.darkPageBackground,),
          if (showLoader) const FullscreenLoader(),
        ],
      ),
    );
  }

  Widget _body() {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            color: AppColor.backgroundPageBody,
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: AppColor.backgroundPageHeader,
                  child: Container(
                    child: _bodyHeader(),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundPageBody,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    height: 20,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: Colors.grey),
                Consumer<RecentTaskProvider>(
                    builder: (_, RecentTaskProvider recentTasksProvider, __) {
                      return Container(
                        color: AppColor.backgroundPageBody,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                            recentTasksProvider?.recentTasks?.tasks?.length??0,
                            itemBuilder: (context, index) {
                              return Consumer<TimeTrackerProvider>(builder: (_,
                                  TimeTrackerProvider timeTrackerProvider, __) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        '${recentTasksProvider.recentTasks?.tasks[index]?.title}',
                                        style: AppTextStyle
                                            .recentTasksListViewTitle,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top:9.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'lib/assets/icons/project.svg',
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${recentTasksProvider.recentTasks?.tasks[index]?.project?.name}',
                                              style: AppTextStyle
                                                  .recentTasksListViewSubTitle,
                                            )
                                          ],
                                        ),
                                      ),
                                      trailing: InkWell(
                                        onTap: () =>
                                            startTimer(timeTrackerProvider,
                                              recentTasksProvider.recentTasks?.tasks[index].id,
                                              recentTasksProvider.recentTasks?.tasks[index].projectId,
                                              recentTasksProvider.recentTasks?.tasks[index].description,

                                            ),
                                        child: SvgPicture.asset(
                                          'lib/assets/icons/play_timer.svg',
                                            color: ((timeTrackerProvider.currentTimer!=null)&&(timeTrackerProvider.timerData.taskId==
                                                recentTasksProvider.recentTasks?.tasks[index].id))?
                                            Colors.green:Colors.grey
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    )
                                  ],
                                );
                              });
                            }),
                      );
                    })
              ],
            ),
          ),
        ),
      );
    });
  }

  startTimer(TimeTrackerProvider timeTrackerProvider,int taskId,int projectId,String description) async {
    final response = await Api().startTimer(
        project_id: projectId,
        task_id: taskId,
        description: description);
    if (response?.baseIowise?.status == 'success') timeTrackerProvider.startOneSecondTimer();
  }

  Widget _bodyHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Recent tasks',
          style: AppTextStyle.pageBodyTitle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 16,
            ),
            backButton(
              context,
            ),
          ],
        )
      ],
    );
  }

  Widget _pageHeader( ) {
   return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __)
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          avatar(profileProvider.avatarUrl, _navigateToProfilePage,
              profileProvider.fullName),
          Text(
            'Time Tracker',
            style: AppTextStyle.pageTitle,
          ),
          InkWell(
            onTap: ()=> Navigator.pop(context),
            child: SvgPicture.asset(
              'lib/assets/icons/clear.svg',
              color: AppColor.primary,
              width: 14,
              height: 13,
            ),
          ),
        ],
      );
    });
  }
}

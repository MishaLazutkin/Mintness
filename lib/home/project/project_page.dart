import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mintness/home/addTask/add_task.dart';
import 'package:mintness/home/update_time/update_time.dart';
import 'package:mintness/home/home_page.dart';
import 'package:mintness/home/project/select_users.dart';
import 'package:mintness/home/task/task_page.dart';
import 'package:mintness/models/domain/project_timeline.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/constants.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/accept_decline_dialog.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/buble_tabbar.dart';
import 'package:mintness/widgets/circle.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/status.dart';
import 'package:mintness/widgets/tasklist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../style.dart';
import 'edit_task/edit_task.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key key, this.project_id}) : super(key: key);

  final project_id;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with FullscreenLoaderMixin<ProjectPage>, TickerProviderStateMixin {
  bool _showCompleted = false;
  TabController _tabController;
  int _currentTabIndex = 0;
  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items = [];
  ReceivePort _port = ReceivePort();
  String _localPath;
  bool _permissionReady;
  bool debug = true;

  void _navigateToAddTaskPage(ProfileProvider profileProvider) {
    NavigationService().push(context, Direction.fromRight,
        AddTaskPage(project_id: widget.project_id));
  }

  void _navigateUpdateTimeheet(int timeSheetId) {
    NavigationService().push(
        context, Direction.fromRight, UpdateTimePage(timeSheetId: timeSheetId));
  }

  void _navigateToUsersList(ProjectProvider projectProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: projectProvider.selectedUsers,
        ));
  }

  void _navigateToEditTaskPage(int taskId) {
    NavigationService()
        .push(context, Direction.fromRight, EditTaskPage(task_id: taskId));
  }

  void _navigateTaskPage(int taskId) {
    NavigationService()
        .push(context, Direction.fromRight, TaskPage(taskId: taskId));
  }

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, const ProfilePage());
  }

  void _navigateToHomePage() {
    NavigationService().push(context, Direction.fromBottom, const HomePage());
  }

  void _initProvider() async {
    runWithLoader(() async {
      await context.read<ProjectProvider>().init(widget.project_id);
    });
  }

  @override
  void initState() {
    super.initState();
    _initTabController();
    Future.microtask(_initProvider);

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    App.globalKey.currentState.context.read<ProjectProvider>().reset();
    _tabController.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  _initTabController() {
    ProjectProvider pp = context.read<ProjectProvider>();
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          _currentTabIndex = _tabController.index;
          switch (_tabController.index) {
            case 0:
              pp.loadFiles(widget.project_id);
              break;
            case 1:
              break;
            case 2:
              break;
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
        builder: (_, ProjectProvider projectProvider, __) {
      return Stack(children: [
        DefaultTabController(
            length: 3,
            child: Consumer<TimeTrackerProvider>(
                builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
              return Scaffold(
                backgroundColor: AppColor.backgroundPageBody,
                body: Column(
                  children: [
                    Column(
                      children: [
                        _header(),
                        _bodyTop(projectProvider, timeTrackerProvider),
                        _tabs(),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _overviewTab(projectProvider),
                          _tasksTab(projectProvider),
                          _timesheetsTab(projectProvider),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })),
        if (showLoader) const FullscreenLoader(),
      ]);
    });
  }

  Widget _tabs() {
    return Container(
      height: 54,
      child: AppBar(
        primary: false,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: AppColor.backgroundPageBody,
        bottom: BubbleTabBar(
          controller: _tabController,
          isScrollable: false,
          headerWidget: Container(),
          labelStyle: AppTextStyle.tabSelectedTitle,
          unselectedLabelStyle: AppTextStyle.tabUnselectedTitle,
          indicator: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          tabs: [
            _individualTab('Overview'),
            _individualTab('Tasks'),
            _individualTab('Timesheets'),
          ],
        ),
      ),
    );
  }

  Widget _bodyTop(ProjectProvider projectProvider,
      TimeTrackerProvider timeTrackerProvider) {
    return Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
      return Stack(children: [
        Container(color: timeTrackerProvider.timerData?.headerColor,height: 50,),
        Container(
          decoration: BoxDecoration(
            boxShadow: [AppConstants.boxShadowHeader],
            color: AppColor.lightPageBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0),
            child: Column(
              children: [
                _bodyHeader(projectProvider),
                SizedBox(
                  height: 14,
                ),
                _status(projectProvider),
                SizedBox(
                  height: 20,
                ),
                _assignedHeader(projectProvider),
              ],
            ),
          ),
        ),
      ]);
    });
  }

  Widget _overviewTab(ProjectProvider projectProvider) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        //height: MediaQuery.of(context).size.height * 4,
        color: AppColor.backgroundPageBody,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Timeline',
                style: AppTextStyle.pageBodyItem,
              ),
              _timeLine(projectProvider),
              SizedBox(
                height: 20,
              ),
              Text(
                'Files',
                style: AppTextStyle.pageBodyItem,
              ),
              SizedBox(
                height: 20,
              ),
              _buildFilesContent(projectProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fileList(ProjectProvider projectProvider) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: projectProvider?.fileList?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Center(
                          child: setMymeType(
                              projectProvider?.fileList[index]['mime_type'])),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                              '${projectProvider?.fileList[index]['name']}'))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _tasksTab(ProjectProvider projectProvider) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text('Show Completed'),
                  SizedBox(
                    width: 10,
                  ),
                  CupertinoSwitch(
                    activeColor: AppColor.switchActiveColor,
                    value: _showCompleted,
                    onChanged: (value) {
                      setState(() {
                        _showCompleted = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: projectProvider.tasksByProjectId?.length,
                  itemBuilder: (context, index) {
                    if ((!_showCompleted) &&
                        (projectProvider.tasksByProjectId[index].completedAt !=
                            null)) return Container();
                    return Consumer<TimeTrackerProvider>(builder:
                        (_, TimeTrackerProvider timeTrackerProvider, __) {
                      return InkWell(
                        onTap: () => _navigateTaskPage(
                            projectProvider.tasksByProjectId[index].id),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              side: BorderSide(width: 5, color: Colors.white)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 10,
                                        child: Text(
                                          '${projectProvider.tasksByProjectId[index].title}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              decoration: (projectProvider
                                                          .tasksByProjectId[
                                                              index]
                                                          .completedAt !=
                                                      null)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        )),
                                    Flexible(
                                      flex: 1,
                                      child: _popupTaskMenu(
                                          projectProvider,
                                          projectProvider
                                              .tasksByProjectId[index].id),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0.0,
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          child: TaskListWidget(
                                            tasklist: projectProvider
                                                .tasksByProjectId[index]
                                                .taskList
                                                .name,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'lib/assets/icons/subtasks.svg',
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 25,
                                          height: 25,
                                          child: Center(
                                            child: Text(
                                              '${projectProvider.tasksByProjectId[index].subtasksCount}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppColor.subtasks,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        if (projectProvider
                                                .tasksByProjectId[index]
                                                .filesCount >
                                            0)
                                          SvgPicture.asset(
                                            'lib/assets/icons/file.svg',
                                          ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    Consumer<ProfileProvider>(builder: (_,
                                        ProfileProvider profileProvider, __) {
                                      return Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: AssignedUsers(
                                            listUsers: projectProvider
                                                .tasksByProjectId[index].users
                                                .map((user) => {
                                                      'avatar': user.avatar,
                                                      'name': user.name
                                                    })
                                                .toList(),
                                            visibilityPlusButton: false,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 16.0, right: 20),
                                  child: Consumer<TimeTrackerProvider>(builder:
                                      (_,
                                          TimeTrackerProvider
                                              timeTrackerProvider,
                                          __) {
                                    return Row(
                                      children: [
                                        StatusWidget(
                                          text: projectProvider
                                              .tasksByProjectId[index]
                                              .status
                                              .name,
                                          color: projectProvider
                                              .tasksByProjectId[index]
                                              .status
                                              .color,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        priorityImage(
                                            imageUrl: projectProvider
                                                .tasksByProjectId[index]
                                                .priority
                                                ?.icon),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SvgPicture.asset(
                                            'lib/assets/icons/timer.svg',
                                            color: ((timeTrackerProvider
                                                            .currentTimer !=
                                                        null) &&
                                                    (timeTrackerProvider
                                                            .timerData.taskId ==
                                                        projectProvider
                                                            .tasksByProjectId[
                                                                index]
                                                            .id))
                                                ? Colors.green
                                                : Colors.grey),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${((timeTrackerProvider.currentTimer != null) && (timeTrackerProvider.timerData.taskId == projectProvider.tasksByProjectId[index].id)) ? '${timeTrackerProvider.timerData.currentSession}' : '00:00'}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${DateFormat('MM/dd/yyyy').format(projectProvider.tasksByProjectId[index].taskEndDate)}',
                                              style: AppTextStyle.cardDate,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }))
                            ],
                          ),
                        ),
                      );
                    });
                  }),
            ),
          ],
        ),
      ),
    );
    //
  }

  Widget _timesheetsTab(ProjectProvider projectProvider) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: GroupedListView<dynamic, String>(
          shrinkWrap: true,
          elements: projectProvider?.timeSheets,
          groupBy: (element) => '${element['date']}',
          groupComparator: (value1, value2) => value2?.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1['from']?.compareTo(item2['from']),
          order: GroupedListOrder.ASC,
          groupSeparatorBuilder: (String value) {
            List<dynamic> list = projectProvider.timeSheets
                .where((element) => element['date'] == value)
                .toList()
                .map((e) => e['duration'])
                .toList();
            int duration_across_day = 0;
            list.forEach((duration) {
              duration_across_day = duration_across_day + duration;
            });
            return Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 20),
              child: Container(
                color: Color.fromRGBO(243, 245, 250, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/calendar.svg',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('${projectProvider.timeSheetDateFrom(value)}',
                                style: AppTextStyle.calendarItem),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/24time.svg',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${durationString(duration_across_day)}',
                              style: AppTextStyle.timeItem,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemBuilder: (c, element) {
            return Container(
              margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Consumer<ProfileProvider>(
                      builder: (_, ProfileProvider profileProvider, __) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icons/circle_timesheet.svg',
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  '${element['taskname']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              if (element['userId'] == profileProvider.userId)
                                _popupTimesheetsMenu(
                                    projectProvider, element['id'])
                            ],
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 23, top: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${element['description']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/icons/24time.svg',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${element['formattedduration']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Circle(color: Colors.grey, radius: 2),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${element['from']} - ${element['to']}',
                                  style: TextStyle(color: AppColor.secondary),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            );
          }),
    );
  }

  Widget _individualTab(String title) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        height: 20,
        width: double.infinity,
        // decoration: BoxDecoration(
        //     border: Border(
        //         right: BorderSide(
        //             color: HexColor('#ACB4BE'), width: 1, style: BorderStyle.solid))),
        child: Text(
          title,
          //maxLines: 1,
        ),
      ),
    );
  }

  Widget _header() {
    return Consumer<TimeTrackerProvider>(
        builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
      return Container(
        child: Consumer<ProfileProvider>(
            builder: (_, ProfileProvider profileProvider, __) {
          return Padding(
            padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: MediaQuery.of(context).viewPadding.top),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
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
                            'Projects',
                            style: AppTextStyle.pageTitle,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        avatar(profileProvider.avatarUrl,
                            _navigateToProfilePage, profileProvider.fullName),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        }),
        color: timeTrackerProvider.timerData?.headerColor,
      );
    });
  }

  Widget _assignedHeader(ProjectProvider projectProvider) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 136,
            child: CustomButton(
              height: 32,
              text: 'Add Task',
              onTap: isCurrentUserIsManager(
                          profileProvider.userId, projectProvider) &&
                      isCurrentUserIsAdmin(profileProvider.userRoleId)
                  ? () => _navigateToAddTaskPage(profileProvider)
                  : () {},
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          //  Spacer(),
          Expanded(
            child: AssignedUsers(
              listUsers: projectProvider?.selectedUsers,
              visibilityPlusButton:
                  projectProvider.projectName == 'General' ? false : true,
              onTap: isCurrentUserIsManager(
                          profileProvider.userId, projectProvider) &&
                      isCurrentUserIsAdmin(profileProvider.userRoleId)
                  ? () => _navigateToUsersList(projectProvider)
                  : () {},
            ),
          )
        ],
      );
    });
  }

  Widget _timeLine(ProjectProvider projectProvider) {
    if (projectProvider?.isInited == false) return Container(height: 500,);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: projectProvider?.listTimeline?.length,
      itemBuilder: (context, index) {
        Timeline item = projectProvider?.listTimeline[index];
        Map<String, dynamic> tasklist = projectProvider.taskList(
            (projectProvider.listTimeline[index].items
                .firstWhere((element) => element.taskListId != null)
                .taskListId));
        return Container(
          child: ConfigurableExpansionTile(
            header: Flexible(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [AppConstants.boxShadowCard],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(21.0),
                                child: Text(
                                  '${projectProvider.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].name : ''}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/tasks.svg',
                            width: 14,
                            height: 16.8,
                          ),
                          SizedBox(
                            width: 10.4,
                          ),
                          Container(
                            width: 33,
                            height: 23,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].notCompleteTasksCount : '0'}/'
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].tasksCount : '0'}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.subtasks,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SvgPicture.asset(
                            'lib/assets/icons/milestone.svg',
                            width: 16,
                            height: 18,
                          ),
                          SizedBox(
                            width: 10.4,
                          ),
                          Container(
                            width: 33,
                            height: 23,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].notCompleteMilestonesCount : '0'}/'
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].milestonesCount : '0'}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.0),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.subtasks,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          SizedBox(
                            width: 17,
                          ),
                          SvgPicture.asset(
                            'lib/assets/icons/drop_down.svg',
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            headerExpanded: Flexible(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [AppConstants.boxShadowCard],
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(21.0),
                                child: Text(
                                  '${projectProvider.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].name : ''}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/tasks.svg',
                            width: 14,
                            height: 16.8,
                          ),
                          SizedBox(
                            width: 10.4,
                          ),
                          Container(
                            width: 33,
                            height: 23,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].notCompleteTasksCount : ' '}/'
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].tasksCount : ' '}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.subtasks,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          SvgPicture.asset(
                            'lib/assets/icons/milestone.svg',
                            width: 16,
                            height: 18,
                          ),
                          SizedBox(
                            width: 10.4,
                          ),
                          Container(
                            width: 33,
                            height: 23,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].notCompleteMilestonesCount : ''}/'
                                  '${projectProvider?.listTimeline?.isNotEmpty ?? false ? projectProvider.listTimeline[index].milestonesCount : ''}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.0),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.subtasks,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          SizedBox(
                            width: 17,
                          ),
                          SvgPicture.asset(
                            'lib/assets/icons/drop_up.svg',
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [AppConstants.boxShadowCard],
                ),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Row(
                              children: [
                                Text(
                                    '${tasklist != null ? tasklist['name'] : ''}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          thickness: 1,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: item.items.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index > 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Divider(
                                        height: 0.0,
                                        thickness: 1,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 17.0,
                                        right: 17.0,
                                        top: 17,
                                        bottom: 7.0),
                                    child: Row(
                                      children: [
                                        item.items[index].type == "task"
                                            ? SvgPicture.asset(
                                                'lib/assets/icons/tasks.svg',
                                                width: 16,
                                                height: 18,
                                              )
                                            : SvgPicture.asset(
                                                'lib/assets/icons/milestone.svg',
                                                width: 14,
                                                height: 16.8,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                                '${item.items[index].title}'))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 10,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (item.items[index].status !=
                                                  null)
                                                StatusWidget(
                                                  text:
                                                      '${item.items[index].status.name}',
                                                  color: item.items[index]
                                                      .status.color,
                                                ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              priorityImage(
                                                  imageUrl: item.items[index]
                                                      .priority?.icon),
                                            ],
                                          ),
                                        ),
                                        // Spacer(),
                                        Flexible(
                                          flex: 14,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                AssignedUsers(
                                                  listUsers: item
                                                      .items[index].users
                                                      .map((user) {
                                                    return {
                                                      'avatar': user.avatar,
                                                      'id': user.id,
                                                      'name': user.name
                                                    };
                                                  }).toList(),
                                                  visibilityPlusButton: false,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Container(
                                                  //width:70,
                                                  child: Text(
                                                    '${DateFormat('MM.dd.yyyy').format(item.items[index].endDate)}',
                                                    style:
                                                        AppTextStyle.cardDate,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _status(ProjectProvider projectProvider) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _popupStatusesMenu(projectProvider, profileProvider),
              SizedBox(
                width: 10,
              ),
              _popupPrioritiesMenu(projectProvider, profileProvider),
            ],
          ),
          Text(
            '${projectProvider.to}',
            style: AppTextStyle.cardDate,
          )
        ],
      );
    });
  }

  Widget _bodyHeader(ProjectProvider projectProvider) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          backButton(
            context,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '${projectProvider?.projectName ?? 'Project'}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyle.pageBodyTitle,
              ),
            ),
          ),
          Container(),
        ],
      ),
    ]);
  }

  Widget _popupTaskMenu(ProjectProvider projectProvider, int task_id) =>
      Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return PopupMenuButton<int>(
          child: Container(
            height: 35,
            width: 35,
            child: SvgPicture.asset(
              'lib/assets/icons/more.svg',
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          itemBuilder: (context) {
            if (isCurrentUserIsManager(
                    profileProvider.userId, projectProvider) &&
                isCurrentUserIsAdmin(profileProvider.userRoleId))
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icons/edit.svg',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Edit"),
                    ],
                  ),
                ),
                PopupMenuDivider(
                  height: 10,
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        child: Icon(
                          CupertinoIcons.delete,
                          color: Colors.red,
                          size: 17,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Delete"),
                    ],
                  ),
                ),
              ];
            return null;
          },
          onSelected: (value) {
            if (value == 1)
              _navigateToEditTaskPage(task_id);
            else if (value == 2) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AcceptDeclineAlertDialog(
                    () {
                      projectProvider.deleteTask(
                          task_id, projectProvider.projectId);
                      Navigator.pop(context);
                    },
                    "Delete Task",
                    "Are you sure you want to delete this task? This action is irreversible.",
                  );
                },
              );
            }
          },
        );
      });

  Widget _popupTimesheetsMenu(
          ProjectProvider projectProvider, int timesheetId) =>
      Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return PopupMenuButton<int>(
          child: Container(
            height: 35,
            width: 35,
            child: SvgPicture.asset(
              'lib/assets/icons/more.svg',
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/edit.svg',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuDivider(
                height: 10,
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      child: Icon(
                        CupertinoIcons.delete,
                        color: Colors.red,
                        size: 17,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete"),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 1)
              _navigateUpdateTimeheet(timesheetId);
            else if (value == 2) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AcceptDeclineAlertDialog(
                    () {
                      projectProvider.deleteTimesheet(
                          timesheetId, projectProvider.projectId);
                      Navigator.pop(context);
                    },
                    "Delete Timesheet",
                    "Are you sure? Once deleted, this timesheet cannot be recovered.",
                  );
                },
              );
            }
          },
        );
      });

  Widget _popupStatusesMenu(
          ProjectProvider projectProvider, ProfileProvider profileProvider) =>
      PopupMenuButton<int>(
        child: Container(
          child: StatusWidget(
              text: projectProvider?.projectStatus['name'] ?? 'Status',
              color: projectProvider != null
                  ? projectProvider?.projectStatus['color']
                  : AppColor.primaryString),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          if (!isCurrentUserIsManager(
                  profileProvider.userId, projectProvider) &&
              !isCurrentUserIsAdmin(profileProvider.userRoleId))
            return List<PopupMenuItem<int>>();
          return projectProvider.listProjectsStatuses
              .map((status) => PopupMenuItem<int>(
                    value: status['id'],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${status['name']}'),
                      ],
                    ),
                  ))
              .toList();
        },
        onSelected: (value) {
          runWithLoader(() async {
            await projectProvider.updateProject({'status_id': value});
          });
        },
      );

  Widget _popupPrioritiesMenu(
      ProjectProvider projectProvider, ProfileProvider profileProvider) {
    return PopupMenuButton<int>(
      child: Container(
        height: 20,
        width: 20,
        child: priorityImage(imageUrl: projectProvider.projectPriority['icon']),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        if (!isCurrentUserIsManager(profileProvider.userId, projectProvider) &&
            !isCurrentUserIsAdmin(profileProvider.userRoleId))
          return List<PopupMenuItem<int>>();
        return projectProvider.priorities
            .map((priority) => PopupMenuItem<int>(
                  value: priority['id'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          priorityImage(imageUrl: priority['icon']),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${priority['name']}'),
                        ],
                      ),
                      PopupMenuDivider(
                        height: 10,
                      ),
                    ],
                  ),
                ))
            .toList();
      },
      onSelected: (value) {
        runWithLoader(() async {
          await projectProvider.updateProject({'priority_id': value});
        });
      },
    );
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task =
            _tasks.firstWhere((task) => task.taskId == id, orElse: () => null);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Widget _buildFilesContent(ProjectProvider projectProvider) {
    _prepareFiles(projectProvider.fileList);
    return Container(child: _buildDownloadList(projectProvider));
  }

  Future<Null> _prepareFiles(List<dynamic> afiles) async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(
        afiles.map((file) => _TaskInfo(name: file['name'], id: file['id'])));

    for (int i = count; i < afiles.length; i++) {
      _items.add(_ItemHolder(
        id: afiles[i]['id'],
        mimeType: afiles[i]['mime_type'],
        name: afiles[i]['name'],
        friendly_size: afiles[i]['friendly_size'],
        task: _tasks[i],
      ));
      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.name == task.filename) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    _createLocalPath();
  }

  _createLocalPath() async {
    _permissionReady = await _checkPermission();
    _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'Download2';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    var directory;
    if (Platform.isAndroid)
      directory = await (getExternalStorageDirectory() as FutureOr<Directory>);
    else
      directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Widget _buildDownloadList(ProjectProvider projectProvider) {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics:NeverScrollableScrollPhysics(),
            itemCount: projectProvider.fileList?.length,
            itemBuilder: (context, index) {
              if (_items.isEmpty)
                return Container();
              else
                return // _items[index]== null?  _buildListSection(_items[index].name):
                    InkWell(
                  child: DownloadItem(
                    projectProvider: projectProvider,
                    data: _items[index],
                    index: index,
                    onItemClick: (task) {
                      _openDownloadedFile(task).then((success) {
                        if (!success) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Cannot open this file.'),
                            ),
                          );
                        }
                      });
                    },
                    onAtionClick: (task) {
                      if (task.status == DownloadTaskStatus.undefined) {
                        _requestDownload(task);
                      } else if (task.status == DownloadTaskStatus.running) {
                        _pauseDownload(task);
                      } else if (task.status == DownloadTaskStatus.paused) {
                        _resumeDownload(task);
                      } else if (task.status == DownloadTaskStatus.failed) {
                        _retryDownload(task);
                      }
                    },
                  ),
                );
            }));
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {

    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }

  Widget _buildListSection(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18.0),
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Loading...'),
      ),
    );
    Map<String, dynamic> file =
        await context.read<ProjectProvider>().getFile(task.id);
    task.taskId = await FlutterDownloader.enqueue(
        url: file['file']['link'],
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);


    setState(() {});
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }
}

class DownloadItem extends StatefulWidget {
  final _ItemHolder data;
  final int index;
  final ProjectProvider projectProvider;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;

  DownloadItem(
      {this.data,
      this.onItemClick,
      this.onAtionClick,
      this.index,
      this.projectProvider});

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: widget.data.task.status == DownloadTaskStatus.complete
            ? () {
                widget.onItemClick(widget.data.task);
              }
            : null,
        child: Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            setMymeType(widget.data.mimeType),
                            SizedBox(
                              width: 10,
                            ),
                            widget.projectProvider.editedFilesIds.contains(
                                    widget.projectProvider
                                        ?.fileList[widget.index]['id'])
                                ? _fileTextfield(
                                    widget.projectProvider, widget.index)
                                : Expanded(
                                    child: Text(
                                        '${widget.projectProvider.fileList[widget.index]['name']}'))
                          ],
                        ),
                      ),
                      widget.projectProvider.editedFilesIds.contains(widget
                              .projectProvider?.fileList[widget.index]['id'])
                          ? _editFileNameButtons(
                              widget.projectProvider, widget.index)
                          : _popupFileMenu(widget.projectProvider,
                              widget.projectProvider?.fileList[widget.index])
                    ],
                  ),
                ),
              ),
            ),
            widget.data.task.status == DownloadTaskStatus.running ||
                    widget.data.task.status == DownloadTaskStatus.paused
                ? Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 5.0,
                    child: LinearProgressIndicator(
                      color: Colors.green,
                      backgroundColor: Colors.white,
                      value: widget.data.task.progress / 100,
                    ),
                  )
                : Container()
          ].where((child) => child != null).toList(),
        ),
      ),
    );
  }

  _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
  }

  Widget _buildActionForTask(
      _TaskInfo task, int file_id, BuildContext context) {
    if (task.status == DownloadTaskStatus.undefined) {
      return InkWell(
        onTap: () {
          widget.onAtionClick(task);
           Navigator.of(context).pop( );
        },
        child: Row(
          children: [
            Icon(
              Icons.file_download,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Download"),
          ],
        ),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          widget.onAtionClick(task);
        },
        child: Row(
          children: [
            Icon(
              Icons.pause,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Downloading"),
          ],
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          widget.onAtionClick(task);
        },
        child: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Resume"),
          ],
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            child: Icon(
              Icons.check_box,
              color: AppColor.backgroundTimerOnHeader,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text("Download"),
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              widget.onAtionClick(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  Widget _fileTextfield(ProjectProvider projectProvider, int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Align(
                  child: TextField(
            controller: projectProvider.listFilesController[index],
            decoration: InputDecoration(
              fillColor: AppColor.textFieldFill,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              counterText: '',
              focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _editFileNameButtons(ProjectProvider projectProvider, int index) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () => setState(() {
                  projectProvider.editedFilesIds
                      .remove(projectProvider?.fileList[index]['id']);
                }),
            child: Icon(Icons.clear, color: AppColor.error)),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () => setState(() async {
            await projectProvider.renameFile(
                projectProvider?.fileList[index]['id'],
                projectProvider.listFilesController[index].text);
            projectProvider.editedFilesIds
                .remove(projectProvider?.fileList[index]['id']);
          }),
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _popupFileMenu(ProjectProvider projectProvider, dynamic file) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return PopupMenuButton<int>(
        child: Container(
          height: 35,
          width: 35,
          child: SvgPicture.asset(
            'lib/assets/icons/more.svg',
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Container(
                    height: 10,
                    child: Icon(
                      Icons.copy,
                      color: AppColor.primary,
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Copy Link"),
                ],
              ),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    child: Icon(
                      Icons.edit,
                      color: AppColor.primary,
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Rename"),
                ],
              ),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            PopupMenuItem(
              value: 3,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    _buildActionForTask(
                        widget.data.task, widget.data.id, context),
                  ],
                );
              }),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            if (isCurrentUserIsManager(
                    profileProvider.userId, projectProvider) &&
                isCurrentUserIsAdmin(profileProvider.userRoleId))
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      child: Icon(
                        CupertinoIcons.delete,
                        color: Colors.red,
                        size: 17,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete"),
                  ],
                ),
              ),
          ];
          return null;
        },
        onSelected: (value) {
          if (value == 1)
            _copyLink(file['link']);
          else if (value == 2) {
            setState(() {
              projectProvider.editedFilesIds.add(file['id']);
            });
          } else if (value == 3) {
           //
          } else if (value == 4) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AcceptDeclineAlertDialog(
                  () {
                    projectProvider.deleteFile(file['id']);
                    Navigator.pop(context);
                  },
                  "Delete File",
                  "Are you sure you want to delete this file? This action is irreversible.",
                );
              },
            );
          }
        },
      );
    });
  }
}

enum subtaskType { closed, opened }

class _TaskInfo {
  final int id;
  final String name;
  final String link;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.id, this.name, this.link});
}

class _ItemHolder {
  final int id;
  final String thumbnailLink;
  final String friendly_size;
  final String name;
  final String mimeType;
  final String date;
  final _TaskInfo task;

  _ItemHolder(
      {this.id,
      this.mimeType,
      this.name,
      this.task,
      this.thumbnailLink,
      this.friendly_size,
      this.date});
}

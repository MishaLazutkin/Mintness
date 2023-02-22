import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/home/project/edit_task/edit_task.dart';
import 'package:mintness/home/task/select_users_task.dart';
import 'package:mintness/home/task/subtasks_tab.dart';
import 'package:mintness/home/task/timesheets_tab.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/constants.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/buble_tabbar.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/status.dart';
import 'package:provider/provider.dart';
import '../../style.dart';
import 'comments_tab.dart';
import 'files_tab.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    Key key,
    this.taskId,
  }) : super(key: key);

  final taskId;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with FullscreenLoaderMixin<TaskPage> {
  bool _showDescription = false;

  void _navigateToUsersList(TaskProvider taskProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: taskProvider.selectedUsers,
        ));
  }

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, ProfilePage());
  }

  void _navigateEditTask(int taskId) {
    NavigationService().push(
        context,
        Direction.fromRight,
        EditTaskPage(
          task_id: taskId,
        ));
  }

  void _initProvider() async {
    runWithLoader(() async {
      await context.read<TaskProvider>().init(widget.taskId);
      await context.read<ProfileProvider>().init();
    });
  }



  @override
  void initState() {
    super.initState();
    Future.microtask(_initProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
      return Stack(children: [
        DefaultTabController(
            length: 4,
            child: Scaffold(
                body: Column(
              children: [
                Consumer<TimeTrackerProvider>(
                    builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
                  return Container(
                      color: timeTrackerProvider.timerData?.headerColor,
                      child: Column(
                        children: [
                          Container(
                            child: _header(timeTrackerProvider),
                            color: timeTrackerProvider.timerData?.headerColor,

                          ),
                      Container(
                        color: timeTrackerProvider.timerData?.headerColor,
                        child: Column(
                          children: [
                              _bodyTop(taskProvider),
                              _tabs(taskProvider),
                            ]),
                      )

                        ],
                      ));
                }),
                Expanded(
                  child: TabBarView(
                    children: [
                      _commentsTab(taskProvider),
                      _subtasksTab(taskProvider?.task?.task?.id),
                      _timesheetsTab(taskProvider?.task?.task?.id),
                      _filesTab(taskProvider?.task?.task?.id),
                    ],
                  ),
                ),
              ],
            ))),
        if (showLoader) const FullscreenLoader(),
      ]);
    });
  }

  Widget _bodyTop(TaskProvider taskProvider) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [AppConstants.boxShadowHeader],
        color: AppColor.lightPageBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0),
        child: Column(
          children: [
            _bodyHeader(taskProvider),
            SizedBox(
              height: 23,
            ),
            _statusPriorityDatePanel(taskProvider),
            SizedBox(
              height: 20,
            ),
            _assignedHeader(taskProvider),
            if (_showDescription)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                            '${taskProvider.task.task.description ?? ''}')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tabs(TaskProvider provider) {
    return Container(
      height: 54,
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        primary: false,
        elevation: 0.0,
        backgroundColor: AppColor.backgroundPageBody,
        bottom: BubbleTabBar(
          isScrollable: true,
          headerWidget: Container(),
          indicator: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          labelStyle: AppTextStyle.tabSelectedTitle,
          unselectedLabelStyle: AppTextStyle.tabUnselectedTitle,
          tabs: [
            _individualTab('Comments'),
            _individualTab('Subtasks'),
            _individualTab('Timesheets'),
            _individualTab('Files'),
          ],
        ),
      ),
    );
  }

  Widget _commentsTab(TaskProvider provider) {
    return CommentsTab(provider);
  }

  Widget _subtasksTab(int id_task) {
    return SubtasksTab(taskId: id_task);
  }

  Widget _timesheetsTab(int id_task) {
    return TimesheetsTab(id_task: id_task);
  }

  Widget _filesTab(int id_task) {
    return FilesTab(idTask: id_task);
  }

  Widget _individualTab(String title) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        // width: double.infinity,
        // decoration: BoxDecoration(
        //     border: Border(
        //         right: BorderSide(
        //             color: HexColor('#ACB4BE'), width: 1, style: BorderStyle.solid))),
        child: Text(
          title,
          maxLines: 1,
          //style: AppTextStyle.tabSelectedTitle,
        ),
      ),
    );
  }

  Widget _header(TimeTrackerProvider timeTrackerProvider) {
    return Padding(
      padding: EdgeInsets.only(
          left: 15.0, right: 15.0, top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Consumer<ProfileProvider>(
                builder: (_, ProfileProvider profileProvider, __) {
                  return avatar(profileProvider.avatarUrl,
                      _navigateToProfilePage, profileProvider.fullName);
                },
              ),
              Text(
                '${timeTrackerProvider?.timerData?.currentSession}',
                style: timeTrackerProvider.timerData.textStyle,
              ),
              Consumer<TaskProvider>(
                  builder: (_, TaskProvider taskProvider, __) {
                return GestureDetector(
                  onTap: () => timeTrackerProvider.startTimer(
                      timeTrackerProvider,
                      widget.taskId,
                      taskProvider.task.task.projectId,
                      taskProvider.task.task.description),
                  child: Container(
                    child: SvgPicture.asset('lib/assets/icons/play_timer_green.svg',
                        color: timeTrackerProvider.timerData?.timerIconColor),
                  ),
                );
              })
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _assignedHeader(TaskProvider taskProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _showDescription = !_showDescription;
          }),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _showDescription ? 'Hide Description' : 'View Description',
                    style: TextStyle(color: AppColor.secondaryText),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 16,
                    width: 16,
                    child: SvgPicture.asset(
                      _showDescription
                          ? 'lib/assets/icons/drop_up.svg'
                          : 'lib/assets/icons/drop_down.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<ProfileProvider>(
            builder: (_, ProfileProvider profileProvider, __) {
          return Consumer<ProjectProvider>(
              builder: (_, ProjectProvider projectProvider, __) {
            return AssignedUsers(
              listUsers: taskProvider?.selectedUsers,
              onTap: isCurrentUserIsManager(
                      profileProvider.userId, projectProvider)&&
                  isCurrentUserIsAdmin(profileProvider.userRoleId)
                  ? () => _navigateToUsersList(taskProvider)
                  : () {},
            );
          });
        })
      ],
    );
  }

  Widget _statusPriorityDatePanel(TaskProvider taskProvider) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __) {
      return Consumer<ProjectProvider>(
          builder: (_, ProjectProvider projectProvider, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _popupStatusesMenu(
                    taskProvider, profileProvider, projectProvider),
                SizedBox(
                  width: 10,
                ),
                _popupPrioritiesMenu(
                    taskProvider, profileProvider, projectProvider)
              ],
            ),
            Text('${taskProvider?.endDate()}')
          ],
        );
      });
    });
  }

  Widget _bodyHeader(TaskProvider taskProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        backButton(
          context,
        ),
        Flexible(
          child: Text(
            '${taskProvider?.task?.task?.title ?? 'Project'}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextStyle.pageBodyTitle,
          ),
        ),
        Consumer<ProfileProvider>(
            builder: (_, ProfileProvider profileProvider, __) {
          return Consumer<ProjectProvider>(
              builder: (_, ProjectProvider projectProvider, __) {
            return GestureDetector(
              onTap: isCurrentUserIsManager(
                      profileProvider.userId, projectProvider)&&
                  isCurrentUserIsAdmin(profileProvider.userRoleId)
                  ? () => _navigateEditTask(taskProvider?.task?.task?.id)
                  : () {},
              child: Container(
                height: 20,
                width: 20,
                child: SvgPicture.asset(
                  'lib/assets/icons/edit.svg',
                  color: AppColor.primary.withOpacity(0.6),
                ),
              ),
            );
          });
        })
      ],
    );
  }

  Widget _popupStatusesMenu(TaskProvider taskProvider,
          ProfileProvider profileProvider, ProjectProvider projectProvider) =>
      PopupMenuButton<int>(
        child: StatusWidget(
            text: taskProvider?.task?.task?.status?.name ?? 'Status',
            color: taskProvider != null
                ? taskProvider?.task?.task?.status?.color
                : AppColor.primaryString),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          if (!isCurrentUserIsManager(profileProvider.userId, projectProvider)&&
              !isCurrentUserIsAdmin(profileProvider.userRoleId))
            return List<PopupMenuItem<int>>();
          return taskProvider.listTasksStatuses
              .map((status) => PopupMenuItem<int>(
                    value: status['id'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${status['name']}'),
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
            await taskProvider.updateTask({'status_id': value});
          });
        },
      );

  Widget _popupPrioritiesMenu(TaskProvider taskProvider,
      ProfileProvider profileProvider, ProjectProvider projectProvider) {
    return PopupMenuButton<int>(
      child: Container(
        height: 20,
        width: 20,
        child: priorityImage(imageUrl: taskProvider.taskPriority['icon']),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        if (!isCurrentUserIsManager(profileProvider.userId, projectProvider)&&
            !isCurrentUserIsAdmin(profileProvider.userRoleId))
          return List<PopupMenuItem<int>>();
        return taskProvider.priorities
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
          await taskProvider.updateTask({'priority_id': value});
        });
      },
    );
  }
}

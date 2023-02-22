import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mintness/home/task/create_subtask.dart';
import 'package:mintness/home/task/select_users_update_subtask.dart';
import 'package:mintness/home/task/update_subtask.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/providers/update_subtask_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/constants.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/accept_decline_dialog.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/project_name_item.dart';
import 'package:mintness/widgets/status.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class SubtasksTab extends StatefulWidget {
  const SubtasksTab({Key key, this.taskId}) : super(key: key);

  final taskId;

  @override
  _SubtasksTabState createState() => _SubtasksTabState();
}

class _SubtasksTabState extends State<SubtasksTab>
    with FullscreenLoaderMixin<SubtasksTab> {
  bool _showCompleted = false;

  _navigateAddSubtask(int taskId) {
    NavigationService()
        .push(context, Direction.fromRight, CreateSubtaskPage(idTask: taskId));
  }

  void _navigateToUsersList(
      TaskProvider taskProvider,
      UpdateSubtaskProvider updateSubtaskProvider,
      List<Map<String, dynamic>> assignedUsers,
      int subtaskId) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: assignedUsers,
          taskId: widget.taskId,
          subTaskId: subtaskId,
          onTapButton: () => runWithLoader(() async {
            await updateSubtaskProvider
                .assignUsers({'users': assignedUsers}, subtaskId);
            context.read<TaskProvider>().init(widget.taskId);
          }),
        ));
  }

  _navigateUpdateSubtask(int taskId, int subTaskId, int projectId) {
    NavigationService().push(
        context,
        Direction.fromRight,
        UpdateSubtaskPage(
          idTask: widget.taskId,
          idSubtask: subTaskId,
          idProject: projectId,
        ));
  }

  void _navigateAssignUsers(List<Map<String, dynamic>> assignedUsers) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: assignedUsers,
          // onTapButton:()=> runWithLoader(() async {
          //   Map<String, dynamic> body = _setParams(taskProvider);
          //   await updateSubtaskProvider.assignUsers(body);
          // }),
        ));
  }

  void _initProvider() async {
    runWithLoader(() async {
      await context.read<TaskProvider>().init(widget.taskId);
    });
  }

  @override
  void initState() {
    Future.microtask(_initProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(),
        if (showLoader)
          const FullscreenLoader(
            showGrayBackground: false,
          ),
      ],
    );
  }

  Widget _body() {
    return Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
      return Container(
        color: AppColor.backgroundPageBody,
        child: Column(
          children: [_header(taskProvider), _content(taskProvider)],
        ),
      );
    });
  }

  Widget _content(TaskProvider taskProvider) {
    if (!taskProvider.isInited) return Container();
    return Expanded(child: Consumer<UpdateSubtaskProvider>(
        builder: (_, UpdateSubtaskProvider updateSubtaskProvider, __) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: taskProvider.task?.task?.subtasks?.length,
        itemBuilder: (_, int index) {
          if ((!_showCompleted) &&
              (taskProvider.task?.task?.subtasks[index].completeStatus == 1))
            return Container();

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${taskProvider.task?.task?.subtasks[index].title}',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColor.primaryText,
                              fontWeight: FontWeight.w600,
                              decoration: (taskProvider.task?.task
                                          ?.subtasks[index].completeStatus ==
                                      1)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      ),
                      _popupSubtaskMenu(
                          updateSubtaskProvider,
                          taskProvider,
                          taskProvider.task?.task?.id,
                          taskProvider.task?.task?.subtasks[index].id,
                          taskProvider.task?.task?.projectId)
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 150,
                          child: ProjectItemWidget(
                              project_item:
                                  '${taskProvider?.task?.task?.project?.name}'),
                        ),
                        //SizedBox(width: 20,),
                        Consumer<ProfileProvider>(
                            builder: (_, ProfileProvider profileProvider, __) {
                          return Consumer<ProjectProvider>(builder:
                              (_, ProjectProvider projectProvider, __) {
                            return AssignedUsers(
                              listUsers: taskProvider
                                  ?.task?.task?.subtasks[index].users
                                  .map((user) => user.toJson())
                                  .toList(),
                              onTap: isCurrentUserIsManager(
                                      profileProvider.userId, projectProvider)&&
                                  isCurrentUserIsAdmin(profileProvider.userRoleId)
                                  ? () => _navigateToUsersList(
                                      taskProvider,
                                      updateSubtaskProvider,
                                      taskProvider
                                          ?.task?.task?.subtasks[index].users
                                          .map((user) => user.toJson())
                                          .toList(),
                                      taskProvider
                                          ?.task?.task?.subtasks[index].id)
                                  : () {},
                            );
                          });
                        })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          StatusWidget(
                            text: AppConstants.subtasksStatuses.firstWhere(
                                (element) =>
                                    element['id'] ==
                                    taskProvider.task.task.subtasks[index]
                                        .completeStatus)['name'],
                            color: AppConstants.subtasksStatuses.firstWhere(
                                (element) =>
                                    element['id'] ==
                                    taskProvider.task.task.subtasks[index]
                                        .completeStatus)['color'],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          priorityImage(
                              imageUrl: taskProvider
                                  .task.task.subtasks[index].priority.icon),
                        ],
                      ),
                      Consumer<TimeTrackerProvider>(builder:
                          (_, TimeTrackerProvider timeTrackerProvider, __) {
                        return InkWell(
                          onTap: () => timeTrackerProvider.startTimer(
                              timeTrackerProvider,
                              widget.taskId,
                              taskProvider.task.task.projectId,
                              taskProvider.task.task.subtasks[index].title,
                              subtaskId:
                                  taskProvider.task.task.subtasks[index].id),
                          child: timeTrackerProvider.currentTimer == null
                              ? SvgPicture.asset(
                                  'lib/assets/icons/play_timer_green.svg',
                                  width: 25,
                                  height: 25,
                                )
                              :
                              (timeTrackerProvider
                                  .timerData.subtaskId ==
                                  taskProvider
                                      ?.task?.task?.subtasks[index].id)?
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.backgroundTimerOnHeader,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Container(
                                    width: 95,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4 ),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: SvgPicture.asset(
                                              'lib/assets/icons/stopTimer.svg',
                                            ),
                                          ),
                                          Text(
                                            '${timeTrackerProvider?.timerData?.currentSession}',
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ):SvgPicture.asset(
                                'lib/assets/icons/play_timer_green.svg',
                                width: 25,
                                height: 25,
                              ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }));
  }

  Widget _header(TaskProvider taskProvider) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<ProfileProvider>(
                    builder: (_, ProfileProvider profileProvider, __) {
                  return Consumer<ProjectProvider>(
                      builder: (_, ProjectProvider projectProvider, __) {
                    return Flexible(
                        flex: 1,
                        child: Container(
                          height: 32,
                          width: 136,
                          child: CustomButton(
                              text: 'Add Subtask',
                              onTap: isCurrentUserIsManager(
                                      profileProvider.userId, projectProvider)&&
                                  isCurrentUserIsAdmin(profileProvider.userRoleId)
                                  ? () => _navigateAddSubtask(
                                      taskProvider.task.task.id)
                                  : () {}),
                        ));
                  });
                }),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: CupertinoSwitch(
                    activeColor: AppColor.switchActiveColor,
                    value: _showCompleted,
                    onChanged: (value) {
                      setState(() {
                        _showCompleted = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(flex: 1, child: Text('Show Completed'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _popupSubtaskMenu(
          UpdateSubtaskProvider updateSubtaskProvider,
          TaskProvider taskProvider,
          int taskId,
          int subtaskId,
          int projectId) =>
      Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return Consumer<ProjectProvider>(
            builder: (_, ProjectProvider projectProvider, __) {
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
                  profileProvider.userId, projectProvider)&&
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
                _navigateUpdateSubtask(taskId, subtaskId, projectId);
              else if (value == 2) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AcceptDeclineAlertDialog(
                      () {
                        taskProvider.deleteSubtask(subtaskId);
                        taskProvider.init(taskId);
                        Navigator.pop(context);
                      },
                      "Delete Subtask",
                      "Are you sure? Once deleted, this subtask cannot be recovered",
                    );
                  },
                );
              }
            },
          );
        });
      });
}

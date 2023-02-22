
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/home/task/select_users_update_subtask.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/providers/update_subtask_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_label_text_field.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:mintness/widgets/status.dart';
import 'package:provider/provider.dart';

class UpdateSubtaskPage extends StatefulWidget {
  const UpdateSubtaskPage(
      {Key key, this.idTask, this.idProject, this.idSubtask})
      : super(key: key);

  final int idTask;
  final int idSubtask;
  final int idProject;

  @override
  _UpdateSubtaskPageState createState() => _UpdateSubtaskPageState();
}

class _UpdateSubtaskPageState extends State<UpdateSubtaskPage>
    with FullscreenLoaderMixin<UpdateSubtaskPage> {
  TextEditingController _subtaskController = TextEditingController();

  void _navigateToUsersList(UpdateSubtaskProvider updateSubtaskProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: updateSubtaskProvider.assignedUsers,
        ));
  }

  void _initProvider() async {
    runWithLoader(() async {
      UpdateSubtaskProvider updateSubtaskProvider =
          context.read<UpdateSubtaskProvider>();
      await updateSubtaskProvider.init(
        taskId: widget.idTask,
        subTaskId: widget.idSubtask,
       // projectId: widget.idProject,
      );
      _subtaskController.text = updateSubtaskProvider.subtaskName;
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
        Consumer<UpdateSubtaskProvider>(
            builder: (_, UpdateSubtaskProvider updateSubtaskProvider, __) {
          return Scaffold(
            backgroundColor: AppColor.backgroundPageBody,
            body: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    _header(updateSubtaskProvider),
                    _body(updateSubtaskProvider)
                  ],
                ),
              ),
            ),
          );
        }),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }

  Widget _header(UpdateSubtaskProvider updateSubtaskProvider) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Center(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Update Subtask',
                      style: AppTextStyle.pageTitle,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    updateSubtaskProvider.reset();
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.clear),
                      SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
        )
      ],
    );
  }

  Widget _body(UpdateSubtaskProvider updateSubtaskProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 21,
          ),
          RichTextItem( 'Subtask'),
          const SizedBox(height: 5),
          _subtaskTextField(updateSubtaskProvider),
          _assignedPanel(updateSubtaskProvider),
          SizedBox(
            height: 24,
          ),
          _buttonUpdate(updateSubtaskProvider)
        ],
      ),
    );
  }

  Widget _buttonUpdate(UpdateSubtaskProvider updateSubtaskProvider) {
    return CustomButton(
      text: 'Update Subtask',
      onTap: () => runWithLoader(() async {
       if( updateSubtaskProvider.validate()) {
         await updateSubtaskProvider.updateSubtask(
           context,
         );
         TaskProvider taskProvider =context.read<TaskProvider>();
         await taskProvider.init(updateSubtaskProvider.taskId);
         Navigator.of(context).pop();
       }

      }),
      isDisabled: !updateSubtaskProvider.validate(),
    );
  }

  Widget _subtaskTextField(UpdateSubtaskProvider updateSubtaskProvider) {
    return CustomTextField(
      controller: _subtaskController,
      fillColor: AppColor.textFieldFill,
      hintText: 'Aa',
      onTyping: (val) {
        updateSubtaskProvider.subtaskName = val;
      },
    );
  }

  Widget _assignedPanel(UpdateSubtaskProvider updateSubtaskProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextItem(
                'Assigned',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 35,
                child: AssignedUsers(
                  listUsers: updateSubtaskProvider.assignedUsers,
                  onTap: () => _navigateToUsersList(updateSubtaskProvider),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: 1,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichTextItem(
                    'Status',
                  ),
                  SvgPicture.asset(
                    'lib/assets/icons/drop_down.svg',
                  ),
                ],
              ),
              if (updateSubtaskProvider.isInited)
                Column(
                  children: [
                    SizedBox(height: 15,),
                    Container(
                      height: 20,
                      child: _popupStatusesMenu(updateSubtaskProvider),
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 35,
                ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: 1,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichTextItem(
                    'Priority',
                  ),
                  SvgPicture.asset(
                    'lib/assets/icons/drop_down.svg',
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              if (updateSubtaskProvider.isInited)
                Container(
                  height: 20,
                  child:_popupPrioritiesMenu(updateSubtaskProvider),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _popupStatusesMenu(UpdateSubtaskProvider updateSubtaskProvider) =>
      Consumer<UpdateSubtaskProvider>(
          builder: (_, UpdateSubtaskProvider updateSubtaskProvider, __) {
        return PopupMenuButton<int>(
          child: Container(
            child: StatusWidget(
              text: updateSubtaskProvider.selectedSubtaskStatus['name'],
              color: updateSubtaskProvider.selectedSubtaskStatus['color'],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          itemBuilder: (context) {
            return updateSubtaskProvider.subtasksStatuses
                .map((status) => PopupMenuItem<int>(
                      value: status['id'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${status['name']}'),
                        ],
                      ),
                    ))
                .toList();
          },
          onSelected: (value) {
            updateSubtaskProvider.selectedSubtaskStatus = updateSubtaskProvider
                .subtasksStatuses
                .firstWhere((element) => element['id'] == value);
          },
        );
      });

  Widget _popupPrioritiesMenu(UpdateSubtaskProvider updateSubtaskProvider) =>
      Consumer<UpdateSubtaskProvider>(
          builder: (_, UpdateSubtaskProvider updateSubtaskProvider, __) {
        return PopupMenuButton<int>(
            child: Container(
              child: Row(
                children: [
                  priorityImage(
                      imageUrl: updateSubtaskProvider
                          .selectedSubtaskPriority['icon']),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                        '${updateSubtaskProvider.selectedSubtaskPriority['name']}'),
                  )
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            itemBuilder: (context) {
              return updateSubtaskProvider.priorities
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
                          ],
                        ),
                      ))
                  .toList();
            },
            onSelected: (value) {
              updateSubtaskProvider.selectedSubtaskPriority =
                  updateSubtaskProvider.priorities
                      .firstWhere((element) => element['id'] == value);
            });
      });
}

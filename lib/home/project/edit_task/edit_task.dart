import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';

import 'package:mintness/home/project/edit_task/projects_dropdown.dart';
import 'package:mintness/home/project/edit_task/select_users.dart';
import 'package:mintness/providers/edit_task_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/status.dart';
import 'package:mintness/widgets/tasklist.dart';
import 'package:provider/provider.dart';
import '../../../style.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key key, this.task_id}) : super(key: key);

  final int task_id;
  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage>
    with FullscreenLoaderMixin<EditTaskPage> {

  TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _estimateController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  List<File> files = [];
  var _directoryPath;

  String _fileName;
  List<PlatformFile> _paths;

  void _navigateToUsersList(UpdateTaskProvider editTaskProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: editTaskProvider.selectedUsers,
        ));
  }

  _initProvider() async {
    UpdateTaskProvider editTaskProvider = context.read<UpdateTaskProvider>();
    runWithLoader(() async {
      await editTaskProvider.init(widget.task_id);
      _taskController.text=editTaskProvider.task['name'];
      _descriptionController.text=editTaskProvider.description;
      _estimateController.text=editTaskProvider.selectedEstimate;
      _rateController.text=editTaskProvider.selectedRate;
    });

  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_initProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<TimeTrackerProvider>(
            builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
          return Scaffold(
              backgroundColor: timeTrackerProvider.timerData.headerColor,
              body: Consumer<UpdateTaskProvider>(
                  builder: (_, UpdateTaskProvider editTaskProvider, __) {
                return Padding(
                  padding: const EdgeInsets.only(top: 44.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.backgroundPageBody,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child:// editTaskProvider.isInited
                        //  ?
                      _body(editTaskProvider)
                         // : Container()
                  ),
                );
              }));
        }),
        if (showLoader ) const FullscreenLoader( ),
      ],
    );
  }

  Widget _body(UpdateTaskProvider editTaskProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _bodyHeader(editTaskProvider),
                  Divider(
                    thickness: 2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichTextItem(
                                'Project',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                            ProjectsDropDown() ,
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichTextItem(
                                'Task title',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          CustomTextField(
                            controller: _taskController,
                            fillColor: AppColor.textFieldFill,
                            hintText: 'Enter Task Name',
                            onTyping: (val) {editTaskProvider.taskName = val;},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _TSPPanel(editTaskProvider),
                          SizedBox(
                            height: 20,
                          ),
                          RichTextItem('Assigned'),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: AssignedUsers(
                                onTap: () =>
                                    _navigateToUsersList(editTaskProvider),
                                listUsers: editTaskProvider?.selectedUsers ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichTextItem(
                                      'Start',
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                     DateTime date =  await  showPickerDate( editTaskProvider.selectedStartDate);
                                     if(date!=null)
                                     editTaskProvider.selectedStartDate=date;
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroundDropDown,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(editTaskProvider
                                                          .selectedStringStartDate),
                                              SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',

                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Flexible(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichTextItem(
                                      'End',
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        DateTime date =  await  showPickerDate( editTaskProvider.selectedEndDate );
                                        if(date!=null)
                                          editTaskProvider.selectedEndDate=date;
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroundDropDown,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(editTaskProvider
                                                          .selectedStringEndDate),
                                              SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichTextItem(
                                      'Estimate',
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: AppColor.backgroundDropDown,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 10,
                                                child: TextField(
                                                  onChanged: (estimate)  {
                                                    editTaskProvider
                                                            .selectedEstimate =
                                                        estimate;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _estimateController,
                                                  decoration:
                                                      new InputDecoration(
                                                          border: InputBorder
                                                              .none,
                                                          hintText: 'Set',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          12)),
                                                )),
                                            Flexible(
                                              flex: 2,
                                              child: SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Flexible(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichTextItem(
                                      'Rate',
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: AppColor.backgroundDropDown,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 10,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _rateController,
                                                  onChanged: (rate) {
                                                    editTaskProvider
                                                        .selectedRate = rate;
                                                  },
                                                  decoration:
                                                      new InputDecoration(
                                                          border: InputBorder
                                                              .none,
                                                          hintText: '\$',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          12)),
                                                )),
                                            Flexible(
                                              flex: 2,
                                              child: SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: AppTextStyle.label,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 86),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColor.backgroundChatMessage,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: TextField(
                                    controller: _descriptionController,
                                    minLines: 3,
                                    maxLines: 5,
                                    onChanged: (value) {
                                      editTaskProvider.description = value;
                                    },
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Aa...',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12)),
                                  ))),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap:() => _openFileExplorer(editTaskProvider),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/icons/attach.svg',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add Files',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColor.primary),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Builder(
                            builder: (BuildContext context) => _directoryPath !=
                                    null
                                ? ListTile(
                                    title: const Text('Directory path'),
                                    subtitle: Text(_directoryPath),
                                  )
                                : _paths != null
                                    ? Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Scrollbar(
                                            child: ListView.separated(
                                          itemCount: _paths != null &&
                                                  _paths.isNotEmpty
                                              ? _paths.length
                                              : 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final bool isMultiPath =
                                                _paths != null &&
                                                    _paths.isNotEmpty;
                                            final String name =
                                                'File ${index + 1}: ' +
                                                    (isMultiPath
                                                        ? _paths
                                                            .map((e) => e.name)
                                                            .toList()[index]
                                                        : _fileName ?? '...');
                                            final path = _paths
                                                .map((e) => e.path)
                                                .toList()[index]
                                                .toString();

                                            return ListTile(
                                              title: Text(
                                                name,
                                              ),
                                              subtitle: Text(path),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                        )),
                                      )
                                    : const SizedBox(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap:  () => runWithLoader(() async {
                              await editTaskProvider.updateTask(context);
                              context.read<ProjectProvider>().init(editTaskProvider.project['id']);
                            }),
                            child: CustomButton(
                              isDisabled:  editTaskProvider.isDisabledButton ,
                              text: 'Update',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer(UpdateTaskProvider editTaskProvider) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      if (result != null) {
        for (int i = 0; i < result.count; i++) {
          double size = result.files[i].size / 1024 / 1024;
          print('size ${size}');
          print('result.files[i].size ${result.files[i].size}');
          if (size >= 15) {
            toast('The size of file you are uploading must be under 15 MB.',
                type: ToastTypes.error);
            return;
          }
        }
        _paths = result.files;
        files = result.paths.map((path) => File(path)).toList();
        editTaskProvider.files = files;
      }
    } on PlatformException catch (e) {
      print("PlatformException: " + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  Widget _TSPPanel(UpdateTaskProvider editTaskProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichTextItem(
                    'TaskList',
                  ),
                  SvgPicture.asset(
                    'lib/assets/icons/drop_down.svg',
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  //height: 25,
                  child: _popupTaskListMenu(editTaskProvider)),
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
        Flexible(
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
              SizedBox(
                height: 15,
              ),
              Container(height: 20,child: _popupStatusesMenu(editTaskProvider)),

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
        Flexible(
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
              Container(height: 20,child: _popupPrioritiesMenu(editTaskProvider)),

            ],
          ),
        ),
      ],
    );
  }



  Future<DateTime> showPickerDate(context,
      {DateTime initialDate  }) async {
    DateTime picked;
    picked = await openPickerDateDialog(
      context,  initialDate,
    );
    return picked;
  }

  Future<DateTime> openPickerDateDialog(
     BuildContext context,  initialDate
      ) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      //.add(const Duration(days: 500)
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: AppColor.primary,
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );
    return picked;
  }

  Widget _popupStatusesMenu(UpdateTaskProvider updateTaskProvider) {
    return PopupMenuButton<Map<String, dynamic>>(
      child: Container(
        child:  StatusWidget(
          text: updateTaskProvider.selectedStatus!= null ? updateTaskProvider.selectedStatus['name'] ?? '' : '',
          color: updateTaskProvider.selectedStatus != null ? updateTaskProvider.selectedStatus['color'] : null,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        return updateTaskProvider.listStatus
            .map((status) => PopupMenuItem<Map<String, dynamic>>(
                  value: status,
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
        updateTaskProvider.selectedStatus = value;
      },
    );
  }

  Widget _popupTaskListMenu(UpdateTaskProvider updateTaskProvider) {
    return PopupMenuButton<Map<String, dynamic>>(
      child: Container(
        child: TaskListWidget(
            tasklist: updateTaskProvider.selectedTaskList != null
                ? updateTaskProvider.selectedTaskList['name'] ?? ''
                : '')
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        return updateTaskProvider.listTasksList
            .map((tasklist) => PopupMenuItem<Map<String, dynamic>>(
                  value: tasklist,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${tasklist['name']}'),
                    ],
                  ),
                ))
            .toList();
      },
      onSelected: (value) {
        updateTaskProvider.selectedTaskList = value;
      },
    );
  }

  Widget _popupPrioritiesMenu(UpdateTaskProvider updateTaskProvider) {
    return PopupMenuButton<Map<String, dynamic>>(
        child: Container(
          child:   Row(
            children: [
              priorityImage(imageUrl: updateTaskProvider?.priority==null?'':updateTaskProvider.priority['icon']),
              SizedBox(
                width: 5,
              ),
              Text('${updateTaskProvider?.priority==null?'':updateTaskProvider.priority['name']}')
            ],
          )
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return updateTaskProvider.priorities
              .map((priority) => PopupMenuItem<Map<String, dynamic>>(
                    value: priority,
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
          updateTaskProvider.priority = value;
        });
  }

  Widget _bodyHeader(UpdateTaskProvider editTaskProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Edit Task',
          style: AppTextStyle.pageTitle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            InkWell(
              onTap: () async {
                editTaskProvider.reset();
                Navigator.pop(context);
              },
              child: backButton(context,onTapFunc: editTaskProvider.reset),
            ),
          ],
        )
      ],
    );
  }
}

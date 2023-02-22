import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mintness/home/addTask/projects_dropdown.dart';
import 'package:mintness/home/addTask/select_users.dart';
import 'package:mintness/providers/create_task_provider.dart';
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
import '../../style.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key key, this.project_id}) : super(key: key);
  final project_id;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>
    with FullscreenLoaderMixin<AddTaskPage> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _estimateController = TextEditingController();
  TextEditingController _rateController = TextEditingController();

  var _directoryPath;

  String _fileName;
  List<PlatformFile> _paths;
  CreateTaskProvider _createTaskProvider;
  void _navigateToUsersList(CreateTaskProvider createTaskProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: createTaskProvider.selectedUsers,
        ));
  }

  _initProvider() async {
    _createTaskProvider =context.read<CreateTaskProvider>();
    runWithLoader(() async {
      await _createTaskProvider.init(widget.project_id);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(_initProvider);
  }
@override
  void dispose() {
    _createTaskProvider.reset();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<TimeTrackerProvider>(
            builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
          return Scaffold(
              backgroundColor: timeTrackerProvider.timerData?.headerColor,
              body: Consumer<CreateTaskProvider>(
                  builder: (_, CreateTaskProvider createTaskProvider, __) {
                return Padding(
                  padding: const EdgeInsets.only(top: 44.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.backgroundPageBody,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: createTaskProvider.isInited
                          ? _body(createTaskProvider)
                          : _body(createTaskProvider)),
                );
              }));
        }),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }

  Widget _body(CreateTaskProvider createTaskProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _bodyHeader(createTaskProvider),
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
                          SizedBox(
                            height: 4,
                          ),
                          ProjectsDropDown(),
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
                            errorText: createTaskProvider.taskNameError,
                            fillColor: AppColor.textFieldFill,
                            hintText: 'Enter Task Name',
                            onTyping: (val) {
                              createTaskProvider.taskName = val;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _tasklistStatusPriority(createTaskProvider),
                          SizedBox(
                            height: 20,
                          ),
                          RichTextItem('Assigned'),
                          AssignedUsers(
                              onTap: () =>
                                  _navigateToUsersList(createTaskProvider),
                              listUsers: createTaskProvider?.selectedUsers),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            createTaskProvider.assignedError ?? '',
                            style: AppTextStyle.textFieldError,
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
                                        DateTime date = await _openDatePicker(
                                            createTaskProvider
                                                .selectedStartDate);

                                        if (date != null)
                                          createTaskProvider.selectedStartDate =
                                              date;
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroundDropDown,
                                            border: _border(createTaskProvider.startDateError),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${createTaskProvider.selectedStringStartDate}',
                                                style:
                                                    AppTextStyle.dateTimeFields,
                                              ),
                                              SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      createTaskProvider.startDateError ?? '',
                                      style: AppTextStyle.textFieldError,
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
                                        DateTime date = await _openDatePicker(
                                            createTaskProvider.selectedEndDate);
                                        if (date != null)
                                          createTaskProvider.selectedEndDate =
                                              date;
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroundDropDown,
                                            border: _border(createTaskProvider.endDateError),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${createTaskProvider.selectedStringEndDate}',
                                                style:
                                                    AppTextStyle.dateTimeFields,
                                              ),
                                              SvgPicture.asset(
                                                'lib/assets/icons/drop_down.svg',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      createTaskProvider.endDateError ?? '',
                                      style: AppTextStyle.textFieldError,
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
                                          border: _border(createTaskProvider.estimateError),
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
                                                  onChanged: (estimate) {
                                                    createTaskProvider
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      createTaskProvider.estimateError ?? '',
                                      style: AppTextStyle.textFieldError,
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
                                          border: _border(createTaskProvider.rateError),
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
                                                    createTaskProvider
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      createTaskProvider.rateError ?? '',
                                      style: AppTextStyle.textFieldError,
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
                                    onChanged: (value) =>
                                        createTaskProvider.description = value,
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
                            onTap: () => _openFileExplorer(createTaskProvider),
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
                                        child: ListView.separated(
                                          shrinkWrap: true,
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
                                        ),
                                      )
                                    : const SizedBox(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap:()=> _createTask(createTaskProvider),
                            child: CustomButton(
                              text: 'Create Task',
                              isDisabled: !createTaskProvider.validate(),
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

  void _openFileExplorer(CreateTaskProvider createTaskProvider) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      if (result != null) {
        for (int i = 0; i < result.count; i++) {
          double size = result.files[i].size / 1024 / 1024;
          if (size >= 15) {
            toast('The size of file you are uploading must be under 15 MB.',
                type: ToastTypes.error);
            return;
          }
        }
        _paths = result.files;
        createTaskProvider.files =
            result.paths.map((path) => File(path)).toList();
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  Widget _tasklistStatusPriority(CreateTaskProvider createTaskProvider) {
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
              _popupTaskListMenu(createTaskProvider),

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
              _popupStatusesMenu(createTaskProvider),

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
              _popupPrioritiesMenu(createTaskProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bodyHeader(CreateTaskProvider createTaskProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Create New Task',
          style: AppTextStyle.pageTitle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            backButton(context),
          ],
        )
      ],
    );
  }

  Widget _popupStatusesMenu(CreateTaskProvider createTaskProvider) =>
      Consumer<CreateTaskProvider>(
          builder: (_, CreateTaskProvider createTaskProvider, __) {
        return PopupMenuButton<Map<String, dynamic>>(
          child: Container(
          child:  StatusWidget(
              text: createTaskProvider.selectedStatus != null ? createTaskProvider.selectedStatus['name'] ?? 'status' : 'status',
              color: createTaskProvider.selectedStatus != null ? createTaskProvider.selectedStatus['color'] : null,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          itemBuilder: (context) {
            return createTaskProvider.listStatus
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
            createTaskProvider.selectedStatus = value;
          },
        );
      });

  Widget _popupTaskListMenu(CreateTaskProvider createTaskProvider) =>
      Consumer<CreateTaskProvider>(
          builder: (_, CreateTaskProvider createTaskProvider, __) {
        return PopupMenuButton<Map<String, dynamic>>(
          child: Container(
            child:  TaskListWidget(
                tasklist: createTaskProvider.selectedTaskList != null
                    ? createTaskProvider.selectedTaskList['name'] ?? ''
                    : '')
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          itemBuilder: (context) {
            return createTaskProvider.listTasksList
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
            createTaskProvider.selectedTaskList = value;
          },
        );
      });

  Widget _popupPrioritiesMenu(CreateTaskProvider createTaskProvider) =>
      Consumer<CreateTaskProvider>(
          builder: (_, CreateTaskProvider createTaskProvider, __) {
        return PopupMenuButton<Map<String, dynamic>>(
            child: Container(
              child:  Row(
                children: [
                  priorityImage(
                      imageUrl: createTaskProvider.priority != null
                          ? createTaskProvider.priority['icon']
                          : ''),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      '${createTaskProvider.priority != null ? createTaskProvider.priority['name'] ?? 'priority' : 'priority'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            itemBuilder: (context) {
              return createTaskProvider.priorities
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
              createTaskProvider.priority = value;
            });
      });

  Future<DateTime> _openDatePicker(DateTime initialDate) async {
    DateTime temp = await showPickerDate(context, selectedDate: initialDate,duration: 20000,
        lastDate: DateTime.now().add(const Duration(days: 365)));
    setState(() {});
    return temp;
  }

  Border _border(String errorText) {
    if((errorText==null)||(errorText.isEmpty))
      return Border.all(color: Colors.transparent, width: 1);
    else return Border.all(color: AppColor.error );
  }

  void _createTask(CreateTaskProvider createTaskProvider) {
    runWithLoader(() async {
      createTaskProvider.validateForHighlighting();
      if (!createTaskProvider.validate()) return;
      bool result = await createTaskProvider.createTask(context);
      if (result) {
        await context.read<ProjectProvider>().init(widget.project_id);
        Navigator.pop(context);
      }
    });
  }

}

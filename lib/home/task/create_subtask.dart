import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/home/task/select_users_create_subtask.dart';
import 'package:mintness/providers/create_subtask_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:mintness/widgets/status.dart';
import 'package:provider/provider.dart';

class CreateSubtaskPage extends StatefulWidget {
  const CreateSubtaskPage({Key key, this.idTask }) : super(key: key);

  final int idTask;

  @override
  _CreateSubtaskPageState createState() => _CreateSubtaskPageState();
}

class _CreateSubtaskPageState extends State<CreateSubtaskPage>
    with FullscreenLoaderMixin<CreateSubtaskPage> {
  TextEditingController _subtaskController = TextEditingController();

  void _navigateToUsersList(CreateSubtaskProvider createSubtaskTaskProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: createSubtaskTaskProvider.selectedUsers,
        ));
  }

  void _initProvider() async {
    runWithLoader(() async {
      await context.read<CreateSubtaskProvider>().init(widget.idTask );
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
        Consumer<CreateSubtaskProvider>(
            builder: (_, CreateSubtaskProvider createSubtaskProvider, __) {
          return Scaffold(
            backgroundColor: AppColor.backgroundPageBody,
            body: SafeArea(
              child: Container(
                child: Column(
                  children: [_header(createSubtaskProvider), _body(createSubtaskProvider)],
                ),
              ),
            ),
          );
        }),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }

  Widget _header(CreateSubtaskProvider createSubtaskProvider) {
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
                      'Create Subtask',
                      style: AppTextStyle.pageTitle,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    createSubtaskProvider.reset();
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

  Widget _body(CreateSubtaskProvider createSubtaskProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 21,
          ),
          RichTextItem('Subtask'),
          const SizedBox(height: 5),
          _subtaskTextField(createSubtaskProvider),
          _assignedPanel(createSubtaskProvider),
          SizedBox(
            height: 24,
          ),
          _buttonCreate(createSubtaskProvider)
        ],
      ),
    );
  }

  Widget _buttonCreate(CreateSubtaskProvider createSubtaskProvider) {
    return CustomButton(
      text: 'Create Subtask',
      onTap: () => runWithLoader(() async {
        await createSubtaskProvider.createSubtask(context);
        context.read<TaskProvider>().init(widget.idTask);
      }),
      isDisabled: !createSubtaskProvider.validate(),
    );
  }


  Widget _subtaskTextField(CreateSubtaskProvider createSubtaskProvider) {
    return CustomTextField(
      controller: _subtaskController,
      fillColor: AppColor.textFieldFill,
      hintText: 'Aa',
      onTyping: (val) {
        createSubtaskProvider.subtaskName = val;
      },
    );
  }

  Widget _assignedPanel(CreateSubtaskProvider createSubtaskProvider) {
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
              SizedBox(height: 5,),
              AssignedUsers(
                listUsers: createSubtaskProvider.selectedUsers,
                onTap: () => _navigateToUsersList(createSubtaskProvider),
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
                height: 20,
              ),
            if(  createSubtaskProvider.isInited)
              Container(height: 20,child: _popupStatusesMenu(createSubtaskProvider)),

            ],
          ),
        ),
        Container(
          width: 1,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                height: 20,
              ),
              if(createSubtaskProvider.isInited)
                Container(height: 20,child: _popupPrioritiesMenu(createSubtaskProvider)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _popupStatusesMenu(CreateSubtaskProvider createSubtaskProvider) =>
      Consumer<CreateSubtaskProvider>(
          builder: (_, CreateSubtaskProvider createSubtaskProvider, __) {
            return PopupMenuButton<int>(
              child: Container(
                child:  StatusWidget(
                  text: createSubtaskProvider.selectedSubtaskStatus['name'],
                  color:
                  createSubtaskProvider.selectedSubtaskStatus['color'],
                )
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) {
                return createSubtaskProvider.subtasksStatuses
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
                createSubtaskProvider.selectedSubtaskStatus = createSubtaskProvider
                    .subtasksStatuses
                    .firstWhere((element) => element['id'] == value);
              },
            );
          });

  Widget _popupPrioritiesMenu(CreateSubtaskProvider createSubtaskProvider) =>
      Consumer<CreateSubtaskProvider>(
          builder: (_, CreateSubtaskProvider createSubtaskProvider, __) {
            return PopupMenuButton<int>(
                child: Container(
                  child:  Row(
                    children: [
                      priorityImage(
                          imageUrl: createSubtaskProvider
                              .selectedSubtaskPriority['icon']),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            '${createSubtaskProvider.selectedSubtaskPriority['name']}'),
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
                  return createSubtaskProvider.priorities
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
                  createSubtaskProvider.selectedSubtaskPriority =
                      createSubtaskProvider.priorities
                          .firstWhere((element) => element['id'] == value);
                });
          });
}

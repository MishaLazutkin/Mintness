import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mintness/home/messenger/select_users.dart';
import 'package:mintness/providers/messenger_provider.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/assigned_users.dart';
import 'package:mintness/widgets/custom_bottom_bar.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:provider/provider.dart';

import '../../style.dart';

class CreateChannelPage extends StatefulWidget {
  const CreateChannelPage({Key key}) : super(key: key);

  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage>
    with FullscreenLoaderMixin<CreateChannelPage>, TickerProviderStateMixin {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _navigateToUsersList(MessengerProvider messengerProvider) {
    NavigationService().push(
        context,
        Direction.fromRight,
        SelectUsersPage(
          selectedUsers: messengerProvider.selectedUsers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundPageHeader,
      body: Stack(
        children: [
          _body(),
          if (showLoader) const FullscreenLoader(),
      ],) ,
      bottomNavigationBar: CustomBottomBar(4),
    );
  }

  _body() {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Consumer<MessengerProvider>(
                builder: (_, MessengerProvider messengerProvider, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cancel',
                                style: AppTextStyle.cancelButton,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Create Channel',
                              style: AppTextStyle.pageTitle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichTextItem(
                        'Title',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextField(
                    controller: _titleController,
                    fillColor: AppColor.textFieldFill,
                    hintText: 'Aa',
                    onTyping: (val) {
                      messengerProvider.title = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichTextItem(
                        'Description',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextField(
                    controller: _descriptionController,
                    fillColor: AppColor.textFieldFill,
                    hintText: 'Aa',
                    onTyping: (val) {
                      messengerProvider.description = val;
                    },
                  ),
                  Text(
                    'Make private',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'When a channel is set to private,it can only be viewed or joined by invitation.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      CupertinoSwitch(
                        activeColor: AppColor.switchActiveColor,
                        value: messengerProvider.type,
                        onChanged: (value) {
                          setState(() {
                            messengerProvider.type = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AssignedUsers(
                          onTap: () => _navigateToUsersList(messengerProvider),
                          listUsers: messengerProvider?.selectedUsers),
                      Container(
                          width: 100, child: CustomButton(text: 'Send Invite'))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            }),
            Consumer<MessengerProvider>(
                builder: (_, MessengerProvider messengerProvider, __) {
              return Align(
                  alignment: const Alignment(0, 1),
                  child: CustomButton(
                    text: 'Create Channel',
                    onTap: () => _createChannel(messengerProvider),
                  ));
            })
          ]),
        ),
        decoration: BoxDecoration(
          color: AppColor.backgroundPageBody,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
      ),
    );
  }

  _createChannel(MessengerProvider messengerProvider) {
    runWithLoader(() async {
    bool success =  await messengerProvider.createConversation();
    if(success) {

      runWithLoader(()  async {
        await  Future.wait([  messengerProvider.init()]);
        Navigator.pop(context);
      });
      }
    });
  }
}

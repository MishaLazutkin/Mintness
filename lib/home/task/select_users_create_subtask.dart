import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintness/widgets/search_widget.dart';
import 'package:mintness/home/addTask/userslist_tile_widget.dart';
import 'package:mintness/providers/create_subtask_provider.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:provider/provider.dart';
import '../../style.dart';

class SelectUsersPage extends StatefulWidget {
  const SelectUsersPage({Key key, this.selectedUsers}) : super(key: key);
  final List<Map<String,dynamic>> selectedUsers  ;

  @override
  _SelectUsersPageState createState() => _SelectUsersPageState();
}

class _SelectUsersPageState extends State<SelectUsersPage>
    with FullscreenLoaderMixin<SelectUsersPage> {
  String text = '';
  List<Map<String,dynamic>> selectedUsers  ;

  @override
  void initState() {
    super.initState();
    selectedUsers =List.from(widget.selectedUsers);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.primary,
          body: Consumer<CreateSubtaskProvider>(
              builder: (_, CreateSubtaskProvider createSubtaskProvider, __) {
                return WillPopScope(
                  onWillPop: () async {
                    createSubtaskProvider.selectedUsers = widget.selectedUsers ?? [];
                    Navigator.pop(context);
                    return  true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 44.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.backgroundPageBody,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: createSubtaskProvider.isInited
                            ? _body(createSubtaskProvider)
                            : Container()),
                  ),
                );
              }),
        ),
        Consumer<CreateSubtaskProvider>(
            builder: (_, CreateSubtaskProvider createSubtaskProvider, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    text: 'Save', onTap: () {
                    createSubtaskProvider.selectedUsers=selectedUsers;
                    Navigator.pop(context);
                  }),
                ),
              ],);
            }),
        if (showLoader) const FullscreenLoader(showGrayBackground: false),
      ],
    );
  }

  Widget _searchField() {
    return SearchWidget(
      text: text,
      onChanged: (text) => setState(() => this.text = text),
      hintText: 'Search ',
    );
  }

  Widget _body(CreateSubtaskProvider createSubtaskProvider) {
    final allUsers =   createSubtaskProvider.users;
    final users = allUsers?.where(containsSearchText)?.toList()??[];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: headerUsers(selectedUsers)
          ),
          SizedBox(
            height: 10,
          ),
          _searchField(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom:60.0),
              child: ListView(
                children: users.map((user) {
                  final isSelected =
                      selectedUsers.firstWhere((element) => element['id']==user['id'],orElse:() => null )!=null;
                  return UserListTileWidget(
                    user: user,
                    isSelected: isSelected,
                    onSelectedUser: selectUser,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectUser(Map<String,dynamic>  user) {
    final isSelected = selectedUsers.firstWhere((element) => element['id']==user['id'],orElse:() => null )!=null;
    setState(() =>
    isSelected ? selectedUsers.removeWhere((element) => element['id']==user['id']) : selectedUsers.add(user));
  }

  bool containsSearchText(Map<String,dynamic> user) {
    final name = user['name'];
    final textLower = text.toLowerCase();
    final userLower = name.toLowerCase();

    return userLower.contains(textLower);
  }

  List<Map<String,dynamic>> getPrioritizedUsers(List<Map<String,dynamic>> users) {
    final notSelectedUsers = List.of(users)
      ..removeWhere((user) => selectedUsers.contains(user));

    return [
      ...List.of(selectedUsers)
        ..sort(ascendingSort),
      ...notSelectedUsers,
    ];
  }

  static int ascendingSort(Map<String,dynamic> user1, Map<String,dynamic> user2) =>
      user1['name'].compareTo(user2['name']);

  Widget _header( ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Add Users',
          style: AppTextStyle.pageTitle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: AppTextStyle.cancelButton,
              ),
            ),
          ],
        )
      ],
    );
  }


  Widget buildListTile({
    @required String title,
    @required VoidCallback onTap,
    Widget leading,
  }) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }

}

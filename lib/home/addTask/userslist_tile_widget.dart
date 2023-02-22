import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/models/domain/users_of_project.dart';
import 'package:mintness/style.dart';
import 'package:mintness/widgets/other_widgets.dart';

class UserListTileWidget extends StatelessWidget {
  final Map<String,dynamic> user;
  final bool isSelected;
  final ValueChanged<Map<String,dynamic>> onSelectedUser;

  const UserListTileWidget({
    Key key,
    @required this.user,
    @required this.isSelected,
    @required this.onSelectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected? AppColor.darkPageBackground:AppColor.lightPageBackground;
    final style  = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );


    return Container(

      color: selectedColor,
      child:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () => onSelectedUser(user),
          child: Row(
            children: [
              avatar(user['avatar'], null,user['name'] ),
              SizedBox(width: 25,),
              Text(
                '${user['name']}',
                style: style,
              ),
              Spacer(),
              isSelected ? SvgPicture.asset(
                'lib/assets/icons/checkbox_checked_user.svg',
              ) : SvgPicture.asset(
                'lib/assets/icons/checkbox_uchecked_user.svg',
              ),
              // ListTile(
              //   onTap: () => onSelectedUser(user),
              //  // leading:  Container(),
              //   //  avatar(user['avatar'], null,user['name'] ),
              //   title: Text(
              //     '${user['name']}',
              //     style: style,
              //   ),
              //   trailing:
              //   isSelected ? SvgPicture.asset(
              //     'lib/assets/icons/checkbox_checked_user.svg',
              //   ) : SvgPicture.asset(
              //     'lib/assets/icons/checkbox_uchecked_user.svg',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
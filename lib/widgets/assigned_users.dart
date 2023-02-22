import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'other_widgets.dart';

class AssignedUsers extends StatefulWidget {
  AssignedUsers({Key key, this.listUsers=const [],this.onTap,
    this.visibilityPlusButton=true,  this.width=135 }) : super(key: key);

  final List  listUsers;
  final bool visibilityPlusButton;
  final double width;

  Function  onTap;

  @override
  _AssignedUsersState createState() => _AssignedUsersState();
}

class _AssignedUsersState extends State<AssignedUsers> {
  int avatar_count;


  @override
  Widget build(BuildContext context) {
    if(widget.listUsers==null) return Container();
    avatar_count = widget.listUsers.length < 3 ? widget.listUsers.length : 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            height: 36,
            child: ListView.builder(
              shrinkWrap: true,
              //primary: true,
              scrollDirection: Axis.horizontal,
              itemCount: avatar_count+1,
              itemBuilder: (context, index) {
                if( widget.listUsers.length==0) return Container();
                if ((index == 3)&&(avatar_count>=3)) {
                  return Align(
                    widthFactor: 0.35,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Container(
                          width: 30,
                          height: 30,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(18))),
                          child: Center(
                            child: Text('+${widget.listUsers.length-3}',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),
                          ),),
                    ),
                  );
                } else return Align(
                    widthFactor: 0.35,
                    child:((index+1)>(avatar_count))?Container(): CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: avatar((widget.listUsers!=null)&&(widget.listUsers.isNotEmpty)?widget.listUsers[index]['avatar']:
                        null,null,widget.listUsers[index]['name'] )),
                  );
              },
            ),
          ),
        ),
        if( widget.visibilityPlusButton==true)(SizedBox(width: 10,)),
       if( widget.visibilityPlusButton==true) InkWell(
          onTap: widget.onTap,
          child: Container(
            height: 32,
            width: 32,
            child: SvgPicture.asset(
              'lib/assets/icons/add_user.svg',
            ),
          ),
        ) ,
      ],
    );
  }
}

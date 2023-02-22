import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TaskListWidget extends StatefulWidget {
 final String tasklist;
 final String color;
  const TaskListWidget({Key key,this.tasklist,this.color='#2196F3'}) : super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 10,
          child: Container(
            decoration: BoxDecoration(
              color: HexColor(widget.color),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left:8.0,right: 8.0,top:4,bottom:4),
                      child: Text("${widget.tasklist}",
                          overflow:TextOverflow.ellipsis,
                        style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ),
              ],
            ),),
        ),
        Flexible(flex: 2, child: SizedBox())
      ],
    );
  }
}

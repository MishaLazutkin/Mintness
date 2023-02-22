import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProjectItemWidget extends StatefulWidget {
 final String project_item;
  const ProjectItemWidget({Key key,this.project_item}) : super(key: key);

  @override
  _ProjectItemWidgetState createState() => _ProjectItemWidgetState();
}

class _ProjectItemWidgetState extends State<ProjectItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text("${widget.project_item}",style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold
        ),overflow: TextOverflow.ellipsis,),
              ),
            ),
          ],
        ),
      ),
        decoration: BoxDecoration(
          color: HexColor('#2196F3'),
          borderRadius: BorderRadius.circular(16.0),
        ),

    );
  }
}

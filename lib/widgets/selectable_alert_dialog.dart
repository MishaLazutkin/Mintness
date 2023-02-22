import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../style.dart';
import 'other_widgets.dart';


enum ContentsTypes { PRIORITY_GROUPS, PROGRESS_STATUSES,TASKS_LIST,PROJECTS_TASKS_LIST,USERS  }

class SelectableAlertDialog extends StatefulWidget {
  String title;
  Function onTap;
  List< dynamic > givenItems;
  ContentsTypes contentType;

  SelectableAlertDialog(this.title, this.onTap, this.givenItems,this.contentType);

  @override
  _SelectableAlertDialogState createState() => _SelectableAlertDialogState();
}

class _SelectableAlertDialogState extends State<SelectableAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              child: Icon(
                Icons.arrow_downward,
                size: 30,
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL',style: TextStyle(color: AppColor.primaryText),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: _buildContent(widget.contentType)
              ),

            ],
          ),
        ),
      ),
    );
  }

 Widget _buildContent(ContentsTypes contentType){
    switch (contentType){
      case ContentsTypes.PRIORITY_GROUPS:
        return _buildPriorityContent();
      case ContentsTypes.PROGRESS_STATUSES:
        return _buildProgressStatusContent();
      case ContentsTypes.TASKS_LIST:
        return _buildTasksListContent();
      case ContentsTypes.PROJECTS_TASKS_LIST:
        return _buildListOfProjectAndTasksContent();

    }
  }
  
  _buildPriorityContent(){
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: widget.givenItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'name': widget.givenItems[index]['name'],
                  'id': widget.givenItems[index]['id'],
                  'icon': widget.givenItems[index]['icon'],
                });
              },
              child: itemOfDialog(widget.givenItems[index]['name'] ,
                  leading:priorityImage(imageUrl: widget.givenItems[index]['icon']))
            ),
          );
        });
  }


  _buildProgressStatusContent(){
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: widget.givenItems?.length??0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'name': widget.givenItems[index]['name'],
                  'id': widget.givenItems[index]['id'],
                  'color': widget.givenItems[index]['color'],
                });
              },
              child: itemOfDialog(widget.givenItems[index]['name'],color: widget.givenItems[index]['color'])
            ),
          );
        });
  }



    _buildTasksListContent(){
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: widget.givenItems?.length??0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'name': widget.givenItems[index].name,
                  'id': widget.givenItems[index].id
                });
              },
              child: itemOfDialog(widget.givenItems[index].name)
            ),
          );
        });
  }

  _buildListOfProjectAndTasksContent(){
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: widget.givenItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'name': widget.givenItems[index].name,
                  'id': widget.givenItems[index].id
                });

              },
              child: itemOfDialog(widget.givenItems[index].name)
            ),
          );
        });
  }


  Widget itemOfDialog(String title, {String color,Widget leading}){
    return Row(
      children: [
        color!=null?Icon(
          Icons.circle,
          color: HexColor(
              color),
          size: 15,
        ):leading!=null?leading:Container(),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            '${title}',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                 ),
          ),
        ),
      ],
    );
  }
}

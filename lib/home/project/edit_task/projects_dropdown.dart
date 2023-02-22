import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/models/domain/projects.dart';
import 'package:mintness/providers/create_task_provider.dart';
import 'package:mintness/providers/edit_task_provider.dart';
import 'package:provider/provider.dart';

import '../../../style.dart';


class ProjectsDropDown extends StatefulWidget {
  const ProjectsDropDown({Key key, }) : super(key: key);


  @override
  _ProjectsDropDownState createState() => _ProjectsDropDownState();
}

class _ProjectsDropDownState extends State<ProjectsDropDown> {

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateTaskProvider>(
        builder: (_, UpdateTaskProvider provider, __)   {
    return Container(
      height: 40,
      decoration: BoxDecoration(
           color: AppColor.backgroundDropDown,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: provider.project!=null?
      DropdownButton<String>(
          dropdownColor: AppColor.backgroundDropDown,
        value: provider.project['name'],
        isExpanded: true,
        underline: Container(),
        icon: Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: SvgPicture.asset(
            'lib/assets/icons/drop_down.svg',
            width: 25,
            height: 25,
          ),
        ),
        items:
          [ DropdownMenuItem(
            value:  provider.project['name'],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${provider.project['name']}',
                      style: AppTextStyle.itemDropDown,
                    ),
                  ),
                ],
              ),
            ),
          )],

        onChanged: (String value) {
        //  createTaskProvider.setSelectedProject=value;
      }
      ):Container() ,
    );
  });
  }

}

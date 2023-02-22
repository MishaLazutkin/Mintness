import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../style.dart';

typedef void stringCallback( String value);

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({Key key, this.valueList,   this.onValuesSelected}) : super(key: key);

  final List<String> valueList;
  final stringCallback onValuesSelected;


  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: AppColor.backgroundDropDown,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColor.backgroundDropDown,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: DropdownButton<String>(
            value: widget.valueList.elementAt(0),
            isExpanded: true,
            underline: Container(),
            icon:  SvgPicture.asset(
              'lib/assets/icons/drop_down.svg',
              width: 25,
              height: 25,
            ),
            items:widget.valueList
            .map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        value,
                        style: AppTextStyle.itemDropDown,
                      ),

                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (String value) {
              widget.onValuesSelected(value);
            },
          ),
        ),
      ),
    );
  }

}

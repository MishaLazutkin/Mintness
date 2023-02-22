import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../style.dart';
import 'other_widgets.dart';

class DateRangePicker extends StatefulWidget {

  DateTime fromDateTime;
  DateTime toDateTime;


  DateRangePicker({this.fromDateTime, this.toDateTime});

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {

  DateRangePickerSelectionChangedArgs _args;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _args=args;
  }

void _onSubmit(Object value){
    if( _args != null){
      Navigator.pop(context, {"DateFrom": _args.value.startDate ,"DateTo": _args.value.endDate ,});
    }else if((widget.fromDateTime!=null) ){
      Navigator.pop(context,{"DateFrom": widget.fromDateTime ,"DateTo": widget.toDateTime  ,} );
    }else {
      Navigator.pop(context,{"DateFrom": null ,"DateTo": null  ,} );
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: emptyAppBar(),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: SfDateRangePicker(
                    showActionButtons:true,
                  onCancel:() => Navigator.pop(context),
                  onSubmit: _onSubmit ,
                  headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20)),
                  view: DateRangePickerView.month,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      weekendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.error),
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      cellDecoration: BoxDecoration(
                          color: AppColor.backgroundTransparent,
                          borderRadius: BorderRadius.circular(20))),
                  minDate: DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderHeight: 50,
                  ),
                  startRangeSelectionColor: AppColor.primary,
                  endRangeSelectionColor: AppColor.primary,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                 widget.fromDateTime ,
                      widget.toDateTime
                  )
                ),
              ),
            ],
          ),
        ));
  }
}

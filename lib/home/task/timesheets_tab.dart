import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/circle.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';

import '../../style.dart';


class TimesheetsTab extends StatefulWidget {
  const TimesheetsTab({Key key, this.id_task}) : super(key: key);
  final id_task;

  @override
  _TimesheetsTabState createState() => _TimesheetsTabState();
}

class _TimesheetsTabState extends State<TimesheetsTab>
    with FullscreenLoaderMixin<TimesheetsTab> {

  void _initProvider() async {
    await runWithLoader(() {
      context.read<TaskProvider>().init(widget.id_task);
    });
  }

  @override
  void initState() {
    Future.microtask(_initProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GroupedListView<dynamic, String>(
              shrinkWrap: true,
              elements: taskProvider?.timesheets,
              groupBy: (element) => element['date'],
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1['created_at'].compareTo(item2['created_at']),
              order: GroupedListOrder.ASC,
              groupSeparatorBuilder: (String value) => Padding(
                    padding:
                        const EdgeInsets.only(left: 2.0, right: 2.0, top: 24),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/calendar.svg',
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                '${DateFormat('yMMMMd').format(
                                    DateFormat("yyyy-MM-dd").parse(reformatString(value.split(' ')[0])))}',
                                style: TextStyle(
                                    )),

                          ],
                        ),
                        Divider(thickness: 1,)
                      ],
                    ),
                  ),
              itemBuilder: (c, element) {

                return InkWell(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              avatar(element['user']['avatar'],null,element['user']['name']??'' ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text('${element['user']['name']??''}'),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icons/24time.svg',
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${element['formatted_duration']}',
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: 10,
                              ),
                              Circle(color: Colors.grey, radius: 2),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '${element['start']} - ${ element['end']} ',
                                  style: TextStyle(fontSize:14)
                              ),
                            ],
                          ),
                          Divider(thickness: 1,)
                        ],
                      )),
                );
              }),
        );
      }),
    );
  }
//
// // minutes in "hours,minutes,seconds" format
//     String setTimeString(int minuts) {
// if(minuts==null) return '';
//       final int hour = minuts ~/ 60;
//       final int minutes = minuts % 60;
//       if ((hour != 0)&&(minutes!=0) ){
//         return '${hour.toString()}:${minutes.toString()}';
//       }else
//       if ((hour == 0)&&(minutes==0) ){
//         return '';
//       }else
//       if (hour == 0 ){
//         return '0:${minutes.toString()}';
//       }
//       else
//       if (minutes == 0){
//         return '${hour.toString()}:0';
//       }
//     }
}

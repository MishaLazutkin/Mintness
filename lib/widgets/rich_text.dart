import 'package:flutter/material.dart';
import 'package:mintness/style.dart';

class RichTextItem extends StatefulWidget {
  String title;

  RichTextItem(this.title);

  @override
  _RichTextItemState createState() => _RichTextItemState();
}

class _RichTextItemState extends State<RichTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppTextStyle.label,
          children: <TextSpan>[
            TextSpan(
              text: widget.title,
            ),
            TextSpan(
                text: '*',
                style: TextStyle(
                    color: AppColor.error, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

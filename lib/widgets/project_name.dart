import 'package:flutter/material.dart';

class ProjectTitle extends StatelessWidget {
  const ProjectTitle({Key key, this.text}) : super(key: key);
  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${text}',
        style: TextStyle(
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}


import 'package:flutter/material.dart';

class HeadlineWithContent extends StatelessWidget {
  final String headLineText;
  final String content;
  final TextStyle headLineStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Color(0Xff1E1E1E));
  final TextStyle contentStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0Xff717171));
  const HeadlineWithContent(
      {super.key, required this.headLineText, required this.content});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(headLineText, style: headLineStyle),
        Text(content, style: contentStyle),
      ],
    );
  }
}

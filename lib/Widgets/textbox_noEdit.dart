import 'package:flutter/material.dart';

class MyTextBoxNoEdit extends StatelessWidget {
  final String text;
  final String sectionName;
  const MyTextBoxNoEdit({
    super.key,
    required this.text,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500], fontSize: 15),
              ),
              IconButton(
                onPressed: () {},
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                disabledColor: Colors.transparent,
                icon: Icon(Icons.lock),
                color: Colors.transparent,
                highlightColor: Colors.transparent,
              )
            ],
          ),
          //text
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

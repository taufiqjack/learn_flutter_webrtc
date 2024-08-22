import 'package:flutter/material.dart';

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? backgound;
  bool? isAllDay;
  Meeting(this.eventName, this.from, this.to, this.backgound, this.isAllDay);
}

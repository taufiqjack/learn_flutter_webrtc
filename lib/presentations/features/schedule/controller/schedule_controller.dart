import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';
import 'package:learn_flutter_webrtc/core/data_source/meeting.dart';
import 'package:learn_flutter_webrtc/presentations/features/schedule/view/schedule_view.dart';

class ScheduleController extends State<ScheduleView> {
  List<Meeting> getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, 27, 19);
    final DateTime startHut = DateTime.parse('2024-08-17 10:00:00');
    final DateTime endHut = startHut.add(const Duration(hours: 1, minutes: 30));
    final DateTime endTime =
        startTime.add(const Duration(hours: 1, minutes: 30));
    meetings.addAll([
      Meeting('HUT RI 79', startHut, endHut, red, false),
      Meeting('Meeting with Client', startTime, endTime, greeTwo, false),
      // Meeting('Yeay Salary', startTime, endTime, orange, false),
    ]);
    return meetings;
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

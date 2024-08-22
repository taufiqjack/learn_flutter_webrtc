import 'dart:ui';

import 'package:learn_flutter_webrtc/core/data_source/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from!;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to!;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName!;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).backgound!;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay!;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

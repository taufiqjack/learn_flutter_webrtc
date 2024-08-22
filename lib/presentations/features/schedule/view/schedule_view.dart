import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';
import 'package:learn_flutter_webrtc/core/data_source/meeting_data_source.dart';
import 'package:learn_flutter_webrtc/presentations/features/schedule/controller/schedule_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  Widget build(BuildContext context, ScheduleController controller) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: black,
      ),
      body: SfCalendar(
        backgroundColor: black,
        view: CalendarView.month,
        dataSource: MeetingDataSource(controller.getDataSource()),
        monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => ScheduleController();
}

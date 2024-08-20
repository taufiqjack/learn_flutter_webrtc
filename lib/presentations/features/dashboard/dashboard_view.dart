import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';
import 'package:learn_flutter_webrtc/core/constants/container.dart';
import 'package:learn_flutter_webrtc/core/routes/route_constants.dart';
import 'package:learn_flutter_webrtc/presentations/features/janus_client/video_call.dart';
import 'package:learn_flutter_webrtc/presentations/widgets/presentation/common_input_button.dart';
import 'package:learn_flutter_webrtc/presentations/widgets/presentation/common_textstyle.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const CommonText(
          text: 'Flutter WebRTC using Janus Client',
          color: white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CommonInputButton(
                  buttonText: 'Start Video Call',
                  onTap: () => Go.to(
                    const VideoCallView(),
                  ),
                ),
              ),
            )
          ],
        ).paddedLTRB(top: 20, left: 16, right: 16),
      ),
    );
  }
}

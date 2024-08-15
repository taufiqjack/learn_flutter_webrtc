import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:learn_flutter_webrtc/presentations/features/call/controller/call_controller.dart';

class CallView extends StatefulWidget {
  final String callerId, calleeId;
  final dynamic offer;
  const CallView({
    super.key,
    required this.callerId,
    required this.calleeId,
    this.offer,
  });

  Widget build(BuildContext context, CallController controller) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Cahyonoz Call App"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                RTCVideoView(
                  controller.remoteRTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    height: 150,
                    width: 120,
                    child: RTCVideoView(
                      controller.localRTCVideoRenderer,
                      mirror: controller.isFrontCameraSelected,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon:
                        Icon(controller.isAudioOn ? Icons.mic : Icons.mic_off),
                    onPressed: controller.toggleMic,
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end),
                    iconSize: 30,
                    onPressed: controller.leaveCall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: controller.switchCamera,
                  ),
                  IconButton(
                    icon: Icon(controller.isVideoOn
                        ? Icons.videocam
                        : Icons.videocam_off),
                    onPressed: controller.toggleCamera,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => CallController();
}

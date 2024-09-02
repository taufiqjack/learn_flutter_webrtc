import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:learn_flutter_webrtc/core/constants/container.dart';
import 'package:learn_flutter_webrtc/presentations/features/meet_room/controller/meet_room_controller.dart';

class MeetRoomView extends StatefulWidget {
  const MeetRoomView({super.key});

  Widget build(BuildContext context, MeetRoomController controller) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to he Room WebRTC"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 30,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.signaling.openUserMedia(
                          controller.localRenderer, controller.remoteRenderer);
                    },
                    child: const Text("Open camera & microphone"),
                  ).leftPadded(10).rightPadded(10),
                  ElevatedButton(
                    onPressed: () async {
                      controller.createRoom();
                    },
                    child: const Text("Create room"),
                  ).rightPadded(10),
                  ElevatedButton(
                    onPressed: () {
                      // Add roomId
                      controller.signaling.joinRoom(
                        controller.textEditingController.text.trim(),
                        controller.remoteRenderer,
                      );
                    },
                    child: const Text("Join room"),
                  ).rightPadded(10),
                  ElevatedButton(
                    onPressed: () {
                      controller.signaling.hangUp(controller.localRenderer);
                    },
                    child: const Text("Hangup"),
                  )..rightPadded(10),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                          RTCVideoView(controller.localRenderer, mirror: true),
                    ),
                    Expanded(child: RTCVideoView(controller.remoteRenderer)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Join the following Room: "),
                  Flexible(
                    child: TextFormField(
                      controller: controller.textEditingController,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8)
          ],
        ));
  }

  @override
  State<StatefulWidget> createState() => MeetRoomController();
}

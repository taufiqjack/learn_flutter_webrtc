import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/presentations/features/join/controller/join_controller.dart';

class JoinView extends StatefulWidget {
  final String selfCallerId;
  const JoinView({
    super.key,
    required this.selfCallerId,
  });

  Widget build(BuildContext context, JoinController controller) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cahyonoz Call App"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: TextEditingController(
                        text: selfCallerId,
                      ),
                      readOnly: true,
                      textAlign: TextAlign.center,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        labelText: "Your Caller ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                          controller.remoteCallerIdTextEditingController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Remote Caller ID",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.white30),
                      ),
                      child: const Text(
                        "Invite",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        controller.joinCall(
                          callerId: selfCallerId,
                          calleeId: controller
                              .remoteCallerIdTextEditingController.text,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (controller.incomingSDPOffer != null)
              Positioned(
                top: 40,
                child: ListTile(
                  title: Text(
                    "Incoming Call from ${controller.incomingSDPOffer["callerId"]}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call_end),
                        color: Colors.redAccent,
                        onPressed: () {
                          controller.incoming();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.call),
                        color: Colors.greenAccent,
                        onPressed: () {
                          controller.joinCall(
                            callerId: controller.incomingSDPOffer["callerId"]!,
                            calleeId: selfCallerId,
                            offer: controller.incomingSDPOffer["sdpOffer"],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => JoinController();
}

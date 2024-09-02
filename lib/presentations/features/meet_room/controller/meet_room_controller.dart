import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:learn_flutter_webrtc/presentations/features/meet_room/view/meet_room_view.dart';
import 'package:learn_flutter_webrtc/presentations/features/signaling/signaling.dart';

class MeetRoomController extends State<MeetRoomView> {
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    localRenderer.initialize();
    remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  createRoom() async {
    roomId = await signaling.createRoom(remoteRenderer);
    textEditingController.text = roomId!;
    setState(() {});
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

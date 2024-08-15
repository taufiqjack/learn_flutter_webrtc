import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/services/signalling_service.dart';
import 'package:learn_flutter_webrtc/presentations/features/call/view/call_view.dart';
import 'package:learn_flutter_webrtc/presentations/features/join/view/join_view.dart';

class JoinController extends State<JoinView> {
  dynamic incomingSDPOffer;
  final remoteCallerIdTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // listen for incoming video call
    SignallingService.instance.socket!.on("newCall", (data) {
      if (mounted) {
        // set SDP Offer of incoming call
        setState(() => incomingSDPOffer = data);
      }
    });
  }

  incoming() {
    setState(() => incomingSDPOffer = null);
  }

  // join Call
  joinCall({
    required String callerId,
    required String calleeId,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallView(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:janus_client/janus_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:learn_flutter_webrtc/core/component/toast.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';
import 'package:learn_flutter_webrtc/core/constants/constant.dart';
import 'package:learn_flutter_webrtc/core/constants/container.dart';
import 'package:learn_flutter_webrtc/core/hive/hive_const.dart';
import 'package:learn_flutter_webrtc/core/models/message_chat/message_chat.dart';
import 'package:learn_flutter_webrtc/presentations/features/janus_client/conf.dart';
import 'package:learn_flutter_webrtc/presentations/widgets/presentation/common_textstyle.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  late JanusClient client;
  late WebSocketJanusTransport ws;
  late JanusSession session;
  late JanusVideoCallPlugin publishVideo;
  TextEditingController nameController = TextEditingController();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteVideoRenderer = RTCVideoRenderer();
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  MediaStream? remoteVideoStream;
  AlertDialog? incomingDialog;
  AlertDialog? registerDialog;
  AlertDialog? callDialog;
  List<MessageChat> messages = [];
  bool ringing = false;
  bool front = true;
  bool speakerOn = false;
  List<MediaDeviceInfo>? _mediaDevicesList;
  DateTime? currentBackPress;

  Future<bool> willPop() async {
    DateTime now = DateTime.now();

    if (currentBackPress == null ||
        now.difference(currentBackPress!) > const Duration(seconds: 2)) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        currentBackPress = now;
        toast(context, 'exit');
      });
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    FToastBuilder();
    initJanusClient();
    loadDevices();
    navigator.mediaDevices.ondevicechange = (event) async {
      loadDevices();
    };
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _localRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  _selectAudioInput(String deviceId) async {
    if (kDebugMode) {
      print(deviceId);
    }
    await Helper.selectAudioInput(deviceId);
  }

  Future<void> loadDevices() async {
    if (WebRTC.platformIsAndroid || WebRTC.platformIsIOS) {
      //Ask for runtime permissions if necessary.
      var status = await Permission.bluetooth.request();
      if (status.isPermanentlyDenied) {
        print('BLEpermdisabled');
      }
      status = await Permission.bluetoothConnect.request();
      if (status.isPermanentlyDenied) {
        print('ConnectPermdisabled');
      }
    }
    final devices = await navigator.mediaDevices.enumerateDevices();
    setState(() {
      _mediaDevicesList = devices;
    });
  }

  Future<void> localMediaSetup() async {
    await _localRenderer.initialize();
    await publishVideo.initDataChannel();
    await publishVideo.initializeMediaDevices(
        mediaConstraints: {'audio': true, 'video': true});
    _localRenderer.srcObject = publishVideo.webRTCHandle?.localStream;
  }

  makeCall() async {
    await localMediaSetup();
    await publishVideo.initDataChannel();
    var offer = await publishVideo.createOffer(
      audioRecv: true,
      videoRecv: true,
    );
    await publishVideo.call(nameController.text, offer: offer);
    nameController.text = "";
  }

  openRegisterDialog() async {
    registerDialog = await showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: const Text("Register As"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Your Name"),
                      controller: nameController,
                      validator: (val) {
                        if (val == '') {
                          return 'username can\'t be empty! ';
                        }
                        return null;
                      },
                      onFieldSubmitted: (v) {
                        registerUser();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(9)),
                    ElevatedButton(
                      onPressed: () async {
                        LOGGEDBOX.put(CLIENT, nameController.text);
                        await registerUser();
                      },
                      child: const Text("Proceed"),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  makeCallDialog() async {
    callDialog = await showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title:
                const Text("Call Registered User or wait for user to call you"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Name Of Registered User to call"),
                  controller: nameController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await makeCall();
                  },
                  child: const Text("Call"),
                )
              ],
            ),
          );
        });
  }

  initJanusClient() async {
    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    client = JanusClient(
        transport: ws,
        iceServers: [
          RTCIceServer(
              urls: "stun:stun.voip.eutelia.it:3478",
              username: "",
              credential: "")
        ],
        isUnifiedPlan: true);
    session = await client.createSession();
    publishVideo = await session.attach<JanusVideoCallPlugin>();
    await _remoteVideoRenderer.initialize();
    MediaStream? tempVideo = await createLocalMediaStream('remoteVideoStream');
    setState(() {
      remoteVideoStream = tempVideo;
    });
    publishVideo.data?.listen((event) async {
      setState(() {
        messages.add(MessageChat(id: 1, chat: event.text));
      });
    });
    publishVideo.webRTCHandle?.peerConnection?.onConnectionState =
        (connectionState) async {
      if (connectionState ==
          RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        print('connection established');
      }
    };
    publishVideo.remoteTrack?.listen((event) async {
      if (event.track != null && event.flowing == true) {
        remoteVideoStream?.addTrack(event.track!);
        _remoteVideoRenderer.srcObject = remoteVideoStream;
        // this is done only for web since web api are muted by default for local tagged
        // mediaStream
        if (kIsWeb) {
          _remoteVideoRenderer.muted = false;
        }
      }
    });
    publishVideo.typedMessages?.listen((even) async {
      Object data = even.event.plugindata?.data;
      if (data is VideoCallRegisteredEvent) {
        Navigator.of(context).pop(registerDialog);
        print(data.result?.username);
        nameController.clear();
        await makeCallDialog();
      }
      if (data is VideoCallIncomingCallEvent) {
        incomingDialog =
            await showIncomingCallDialog(data.result!.username!, even.jsep);
        LOGGEDBOX.put(NAME, data.result!.username);
      }
      if (data is VideoCallAcceptedEvent) {
        setState(() {
          ringing = false;
        });
        await publishVideo.handleRemoteJsep(even.jsep);
      }
      if (data is VideoCallCallingEvent) {
        Navigator.of(context).pop(callDialog);
        setState(() {
          ringing = true;
        });
      }
      if (data is VideoCallEvent) {
        if (even.jsep != null) {
          if (even.jsep?.type == "answer") {
            publishVideo.handleRemoteJsep(even.jsep);
          } else {
            var answer = await publishVideo.createAnswer();
            await publishVideo.send(jsep: answer);
          }
        }
      }
      if (data is VideoCallHangupEvent) {
        await destroy();
      }
    }, onError: (error) async {
      if (error is JanusError) {
        var dialog;
        dialog = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(dialog);
                        nameController.clear();
                      },
                      child: const Text('Okay'))
                ],
                title: const Text('Whoops!'),
                content: Text(error.error),
              );
            });
      }
    });
    await openRegisterDialog();
  }

  Future<void> registerUser() async {
    if (formKey.currentState?.validate() == true) {
      await publishVideo.register(nameController.text);
    }
  }

  destroy() async {
    await stopAllTracksAndDispose(publishVideo.webRTCHandle?.localStream);
    await stopAllTracksAndDispose(remoteVideoStream);
    publishVideo.dispose();
    session.dispose();
    Navigator.of(context).pop();
  }

  Future<dynamic> showIncomingCallDialog(
      String caller, RTCSessionDescription? jsep) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incoming call from $caller'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    await localMediaSetup();
                    await publishVideo.handleRemoteJsep(jsep);
                    var answer = await publishVideo.createAnswer();
                    await publishVideo.acceptCall(answer: answer);
                    Navigator.of(context).pop(incomingDialog);
                    Navigator.of(context).pop(callDialog);
                  },
                  child: const Text('Accept')),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pop(incomingDialog);
                    Navigator.of(context, rootNavigator: true).pop(callDialog);
                    await publishVideo.hangup();
                  },
                  child: const Text('Reject')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: [
        PopupMenuButton<String>(
          onSelected: _selectAudioInput,
          icon: const Icon(Icons.input),
          itemBuilder: (BuildContext context) {
            if (_mediaDevicesList != null) {
              return _mediaDevicesList!
                  .where((device) => device.kind == 'audioinput')
                  .map((device) {
                return PopupMenuItem<String>(
                  value: device.deviceId,
                  child: Text(device.label),
                );
              }).toList();
            }
            return [];
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Speaker'),
            CupertinoSwitch(
              // This bool value toggles the switch.
              value: speakerOn,
              thumbColor: CupertinoColors.systemBlue,
              trackColor: CupertinoColors.systemRed.withOpacity(0.14),
              activeColor: CupertinoColors.systemRed.withOpacity(0.64),
              onChanged: (bool? value) async {
                // This is called when the user toggles the switch.
                setState(() {
                  speakerOn = value!;
                });
                await Helper.setSpeakerphoneOn(speakerOn);
              },
            ),
          ],
        ),
        IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            color: Colors.white,
            splashRadius: 25,
            onPressed: () async {
              setState(() {
                front = !front;
              });
              // note:- deviceId is important for web browsers
              await publishVideo.switchCamera(
                  deviceId: await getCameraDeviceId(front));

              // everytime we make changes in stream we update in ui and renderer
              // like this.
              setState(() {
                _localRenderer.srcObject =
                    publishVideo.webRTCHandle?.localStream;
              });
            })
      ]),
      body: WillPopScope(
        onWillPop: () => willPop(),
        child: Stack(children: [
          Row(children: [
            Flexible(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      RTCVideoView(
                        _remoteVideoRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                    ))
              ],
            )),
            Flexible(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 2,
                    child: ListView(
                        children: List.generate(
                      messages.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Wrap(
                            alignment: messages[index].id == 1
                                ? WrapAlignment.end
                                : WrapAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: greyLightFour,
                                    borderRadius: BorderRadius.circular(5)),
                                child: CommonText(
                                  text: messages[index].id == 1
                                      ? LOGGEDBOX.get(CLIENT) + ' : '
                                      : LOGGEDBOX.get(NAME) + ' : ',
                                  color: white,
                                ),
                              ),
                              Text(messages[index].chat!),
                            ]),
                      ),
                    ))),
                Flexible(
                    child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(label: Text('Send message')),
                    )),
                    Flexible(
                        child: TextButton(
                            onPressed: () async {
                              await publishVideo
                                  .sendData(messageController.text);
                              setState(() {
                                messages.add(MessageChat(
                                    id: 2, chat: messageController.text));
                              });
                              messageController.clear();
                            },
                            child: const Icon(Icons.send)))
                  ],
                ).paddedLTRB(right: 5, left: 10))
              ],
            ))
          ]),
          Visibility(
              visible: ringing,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: ringing
                          ? Colors.green
                          : Colors.grey.withOpacity(0.3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Ringing...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                  child: IconButton(
                      icon: const Icon(Icons.call_end),
                      color: Colors.white,
                      onPressed: () async {
                        destroy();
                        await publishVideo.hangup();
                        LOGGEDBOX.clear();
                        // destroy();
                      })),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> cleanUpWebRTCStuff() async {
    _localRenderer.srcObject = null;
    _remoteVideoRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteVideoRenderer.dispose();
  }

  @override
  void dispose() async {
    super.dispose();
    Fluttertoast.cancel();
    cleanUpWebRTCStuff();
  }
}

import 'package:flutter/material.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';

class CommonInputButton extends StatelessWidget {
  final String buttonText;
  final bool isEnabled;
  final Color? buttonTextColor;
  final Color? buttonBackgroundColor;
  final Size? size;
  final Function()? onTap;

  const CommonInputButton({
    Key? key,
    required this.buttonText,
    this.isEnabled = true,
    this.buttonTextColor,
    this.buttonBackgroundColor,
    this.onTap,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onTap : null,
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: isEnabled ? buttonBackgroundColor ?? red : greyThree,
          fixedSize: size ?? Size(MediaQuery.of(context).size.width, 48)),
      child: Text(buttonText,
          style: TextStyle(
            color: isEnabled ? buttonTextColor ?? white : white,
          )),
    );
  }
}

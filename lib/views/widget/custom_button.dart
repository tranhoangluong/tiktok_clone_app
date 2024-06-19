import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toptop/views/widget/text.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Color color;

  final VoidCallback onPress;

  const CustomButton({super.key,
    required this.onPress,
    this.text = 'Write text ',
    this.color = Colors.black38,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(10),
        backgroundColor: color,
      ),
      onPressed: onPress,

      child: CustomText(
        alignment: Alignment.center,
        text: text,
        color: Colors.white,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lingopanda_assessment/utils/colors.dart';
import 'package:lingopanda_assessment/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.ontap,
  });

  final double width;
  final double height;
  final String text;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * 0.5,
        height: height * 0.055,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.blue,
        ),
        child: Center(
          child: Text(
            text,
            style: Styles.bodyTextStyle2.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

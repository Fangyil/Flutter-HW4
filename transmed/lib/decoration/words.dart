import 'package:flutter/material.dart';

///空心字体
class HollowText extends StatelessWidget {
  final String text; //内容
  final double size; //字体大小
  final Color hollowColor; //空心颜色
  final double strokeWidth; //描边宽度
  final Color strokeColor; //描边颜色

  const HollowText({
    super.key,
    required this.text,
    required this.size,
    required this.hollowColor,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size,
            color: hollowColor,
          ),
        )
      ],
    );
  }
}

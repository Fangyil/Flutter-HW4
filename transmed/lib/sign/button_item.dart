import 'package:flutter/material.dart';
import 'sign_page.dart';

class Button extends StatefulWidget {
  const Button({super.key, required this.title});

  final String title;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Sign(
                      title: widget.title,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            // 设置渐变色
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF89500),
                Color(0xFFFA6B74),
              ],
            ),
            // 设置投影
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
            // 设置圆角半径
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}

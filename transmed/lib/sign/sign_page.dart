import 'dart:ui';

import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'signup_item.dart';
import 'login_item.dart';

class Sign extends StatefulWidget {
  const Sign({super.key, required this.title});

  final String title;

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  String login = '';
  String token = '';
  String email = '';
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width, // 屏幕宽度
            height: MediaQuery.of(context).size.height, // 屏幕高度
            child: Image.asset(
              "assets/SignBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: 300.0,
                      height: (widget.title == 'SIGN UP') ? 530 : 430,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                      child: Center(
                        child: (widget.title == 'SIGN UP')
                            ? SignUp(title: widget.title)
                            : Login(title: widget.title),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 5,
                  child: Ink(
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Welcome()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

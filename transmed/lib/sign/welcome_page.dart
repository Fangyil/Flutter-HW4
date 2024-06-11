import 'package:flutter/material.dart';
import 'button_item.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
              "assets/WelcomeBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            bottom: 200,
            child: Column(
              children: [
                Button(title: 'LOGIN'),
                SizedBox(height: 50),
                Button(title: 'SIGN UP'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

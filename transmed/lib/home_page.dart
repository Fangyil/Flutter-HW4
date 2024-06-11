import 'package:flutter/material.dart';
import 'package:transmed/profile/profile_page.dart';
import 'package:transmed/chat/screen_page.dart';
import 'package:transmed/disease/alldisease_page.dart';
import 'news/dailynews_page.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key,
      required this.name,
      required this.email,
      required this.token});

  final String name;
  final String email;
  final String token;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //目前選擇頁索引值
  int _currentIndex = 0; //預設值
  late List<StatefulWidget> pages = [
    const DailyNews(),
    const AllDisease(),
    ChatScreen(
      name: widget.name,
    ),
    Profile(
      email: widget.email,
      name: widget.name,
      token: widget.token,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'Daily News'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat Room'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _currentIndex, //目前選擇頁索引值
        fixedColor: Colors.amber, //選擇頁顏色
        onTap: _onItemClick, //BottomNavigationBar 按下處理事件
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  //BottomNavigationBar 按下處理事件，更新設定當下索引值
  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

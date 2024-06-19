import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toptop/views/screens/home/chat/chat_screen.dart';
import 'package:toptop/views/screens/home/user/user_screen.dart';
import 'package:toptop/views/screens/home/video/video_screen.dart';

import 'custom_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tabIndex = 0;
  final List<Widget> _list = [
    VideoScreen(),
    ChatScreen(),
    const UserInfoScreen(),
    const UserInfoScreen()
  ];

  void _changeTabIndex(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: _list[_tabIndex],
        ),
        bottomNavigationBar: CustomAnimatedBottomBar(
          selectedScreenIndex: _tabIndex,
          onItemTap: _changeTabIndex,
        ));
  }
}
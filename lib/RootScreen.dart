import 'package:flutter/material.dart';
import 'package:reciperealm/Profile.dart';
import 'package:reciperealm/widgets/custom_bottom_app_bar.dart';
import 'Options.dart';
import 'CreateRecipeView.dart';
import 'mainmenu.dart';
import 'notifications.dart';

class RootScreen extends StatefulWidget {
  final String token;
  const RootScreen({Key? key, required this.token}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState(token: token);
}

class _RootScreenState extends State<RootScreen> {
  final String token;
  _RootScreenState({required this.token});

  int _currentIndex = 0;

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      mainmenu(token: token),
      CreateRecipeView(token: token),
      notifications(token: token),
      Profile(token: token),
      Options(token: token)
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomAppBar(
        token: token,
        updateIndex: _updateIndex,
        currentIndex: _currentIndex,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

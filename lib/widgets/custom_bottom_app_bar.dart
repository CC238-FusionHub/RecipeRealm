import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final String token;
  final Function(int) updateIndex;
  final int currentIndex;

  const CustomBottomAppBar({
    Key? key,
    required this.token,
    required this.updateIndex,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.grey;
    final unselectedColor = Colors.white;

    return BottomAppBar(
      color: const Color(0xFFA2751D),
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => updateIndex(0),
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? selectedColor : unselectedColor,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () => updateIndex(1),
            icon: Icon(
              Icons.content_paste,
              color: currentIndex == 1 ? selectedColor : unselectedColor,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () => updateIndex(2),
            icon: Icon(
              Icons.email,
              color: currentIndex == 2 ? selectedColor : unselectedColor,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () => updateIndex(3),
            icon: Icon(
              Icons.person,
              color: currentIndex == 3 ? selectedColor : unselectedColor,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () => updateIndex(0),
            icon: Icon(
              Icons.more_horiz,
              color: currentIndex == 0 ? selectedColor : unselectedColor,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
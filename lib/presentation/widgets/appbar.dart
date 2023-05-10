import 'package:flutter/material.dart';

class TopAppbar extends StatefulWidget {
  const TopAppbar({Key? key}) : super(key: key);

  @override
  _TopAppbarState createState() => _TopAppbarState();
}

class _TopAppbarState extends State<TopAppbar> {
  bool _isRedSelected = false;
  bool _isBlueSelected = false;
  bool _isGreenSelected = false;
  bool _isYellowSelected = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My App'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (String value) {
            // Handle dropdown menu selection
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Option 1',
              child: Text('Option 1'),
            ),
            PopupMenuItem<String>(
              value: 'Option 2',
              child: Text('Option 2'),
            ),
            PopupMenuItem<String>(
              value: 'Option 3',
              child: Text('Option 3'),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Handle search button press
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // Handle more options button press
          },
        ),
        ToggleButton(
          text: 'Red',
          isSelected: _isRedSelected,
          onPressed: () {
            setState(() {
              _isRedSelected = !_isRedSelected;
            });
          },
        ),
        ToggleButton(
          text: 'Blue',
          isSelected: _isBlueSelected,
          onPressed: () {
            setState(() {
              _isBlueSelected = !_isBlueSelected;
            });
          },
        ),
        ToggleButton(
          text: 'Green',
          isSelected: _isGreenSelected,
          onPressed: () {
            setState(() {
              _isGreenSelected = !_isGreenSelected;
            });
          },
        ),
        ToggleButton(
          text: 'Yellow',
          isSelected: _isYellowSelected,
          onPressed: () {
            setState(() {
              _isYellowSelected = !_isYellowSelected;
            });
          },
        ),
      ],
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const ToggleButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: isSelected ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
      tooltip: text,
    );
  }
}

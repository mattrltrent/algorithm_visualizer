import 'package:algorithm_visualizer/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class AppleDropdown<T> extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<int> onSelect;

  const AppleDropdown({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
  }) : super(key: key);

  @override
  AppleDropdownState createState() => AppleDropdownState();
}

class AppleDropdownState extends State<AppleDropdown> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(text: widget.selectedOption, onTap: _toggleDropdown);
  }

  void _toggleDropdown() async {
    if (_controller.isAnimating) {
      return;
    }

    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset? position = box?.localToGlobal(Offset.zero);
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect positionRelativeToOverlay = RelativeRect.fromLTRB(
      position!.dx + box!.size.width / 2,
      position.dy + box.size.height / 2,
      overlay.size.width - position.dx - box.size.width / 2,
      overlay.size.height - position.dy - box.size.height / 2,
    );

    final int? index = await showMenu<int>(
      context: context,
      position: positionRelativeToOverlay,
      items: widget.options.asMap().entries.map<PopupMenuEntry<int>>((entry) {
        final index = entry.key;
        final value = entry.value;
        return PopupMenuItem<int>(
          value: index,
          child: Text(value),
        );
      }).toList(),
    );

    if (index != null) {
      widget.onSelect(index);
    }

    _controller.reverse();
  }
}

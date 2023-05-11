import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function onTap;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 75), reverseDuration: const Duration(milliseconds: 50));
    anim = CurvedAnimation(parent: animController, curve: Curves.easeIn, reverseCurve: Curves.linear);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void startAnim() async {
    animController.forward().then((value) {
      animController.reverse();
    });
    animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    animController.reverse();
    animController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() {
            animController.forward();
            animController.addListener(() {
              setState(() {});
            });
          }),
          onTapCancel: () => setState(() {
            animController.reverse();
            animController.addListener(() {
              setState(() {});
            });
          }),
          onTap: () {
            widget.onTap();
            startAnim();
          },
          child: Opacity(
            opacity: -anim.value * 0.3 + 1,
            child: widget.child,
          ),
        ));
  }
}

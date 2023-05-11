import 'package:flutter/material.dart';

class TouchableShrink extends StatefulWidget {
  const TouchableShrink({
    this.tappable = true,
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function onTap;
  final bool tappable;

  @override
  State<TouchableShrink> createState() => _TouchableShrinkState();
}

class _TouchableShrinkState extends State<TouchableShrink> with SingleTickerProviderStateMixin {
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
    return widget.tappable
        ? GestureDetector(
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
            child: Transform.scale(
              scale: -anim.value * 0.05 + 1,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}

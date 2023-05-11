import 'package:flutter/material.dart';

class InitScale extends StatefulWidget {
  /// On [initState], makes the widget animate to its full size.
  const InitScale({
    super.key,
    required this.child,
    this.durationOfScaleInMilliseconds = 450,
    this.delayDurationInMilliseconds = 0,
    this.addedToScale = 0,
  });

  final Widget child;
  final int durationOfScaleInMilliseconds;
  final int delayDurationInMilliseconds;
  final double addedToScale;

  @override
  State<InitScale> createState() => InitScaleState();
}

class InitScaleState extends State<InitScale> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;
  bool _isDisposed = false;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationOfScaleInMilliseconds),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  void startAnim() async {
    if (_isDisposed) return;

    widget.delayDurationInMilliseconds == 0
        ? null
        : await Future.delayed(Duration(milliseconds: widget.delayDurationInMilliseconds));

    if (_isDisposed) return;

    _animController.forward();
    _animController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _anim.value + widget.addedToScale,
      child: widget.child,
    );
  }
}

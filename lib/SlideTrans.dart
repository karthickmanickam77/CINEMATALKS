import 'package:flutter/material.dart';
import 'Moviedetails.dart';

class SlideTransitionImage extends StatefulWidget {
  final String imageUrl;
  final Duration duration;

  SlideTransitionImage({required this.imageUrl, required this.duration});

  @override
  _SlideTransitionImageState createState() => _SlideTransitionImageState();
}

class _SlideTransitionImageState extends State<SlideTransitionImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.network(
        widget.imageUrl,
        height: 320,
        fit: BoxFit.fill,
      ),
    );
  }
}

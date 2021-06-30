import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
class AnimatedImage extends StatefulWidget {
  String imagePath;
  AnimatedImage(this.imagePath);
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 3));
    _animation=Tween(
      begin: 0.0,
      end: 1.0
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: getImage(AssetImage(widget.imagePath), context)
      );
  }
}
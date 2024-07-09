import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CustomLoadingPage extends StatefulWidget {
  const CustomLoadingPage({super.key});

  @override
  _CustomLoadingPageState createState() => _CustomLoadingPageState();
}

class _CustomLoadingPageState extends State<CustomLoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<Widget> _bubbles = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_bubbles.length < 30) {
        setState(() {
          _bubbles.add(AnimatedBubble(random: _random));
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(height: 170, "assets/restaurant.png"),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14,
                      child: child,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ),
          ..._bubbles,
        ],
      ),
    );
  }
}

class AnimatedBubble extends StatefulWidget {
  final Random random;

  const AnimatedBubble({super.key, required this.random});

  @override
  _AnimatedBubbleState createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double left;
  late double size;
  late Color color;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5 + widget.random.nextInt(3)),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      left = widget.random.nextDouble() * MediaQuery.of(context).size.width;
      size = widget.random.nextDouble() * 30 + 10;
      color = Color.fromRGBO(
        (255 - widget.random.nextInt(100)),
        (50 + widget.random.nextInt(50)),
        (50 + widget.random.nextInt(50)),
        1,
      );

      _animation =
          Tween<double>(begin: 0, end: MediaQuery.of(context).size.height)
              .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );

      _controller.forward();
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Container(); // or a placeholder widget
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(left: left, bottom: _animation.value),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

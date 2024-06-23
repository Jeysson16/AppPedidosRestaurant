import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
                strokeWidth: 8,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.amber.withOpacity(.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingPage extends StatefulWidget {
  const CustomLoadingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomLoadingPageState createState() => _CustomLoadingPageState();
}

class _CustomLoadingPageState extends State<CustomLoadingPage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green],
                  ),
                ),
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
    );
  }
}
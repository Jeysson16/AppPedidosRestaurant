import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    Timer(Duration(seconds: 5), () {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo ajustado a tu diseño
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo del restaurante o nombre
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/restaurant.png', // Otra imagen que se desvanece
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height - 100,
              ),
            ),
            const Text(
              'Bienvenido a D\' Gilberth',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Color de texto ajustado a tu diseño
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class MiUbicacionMarker extends StatelessWidget {
  const MiUbicacionMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _AnimatedMarker(),
    );
  }
}

class _AnimatedMarker extends StatefulWidget {
  @override
  _AnimatedMarkerState createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<_AnimatedMarker> {
  late Timer _timer;
  bool _scaleUp = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _scaleUp = !_scaleUp;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _scaleUp ? 40 : 20,
              width: _scaleUp ? 40 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

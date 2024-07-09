import 'package:flutter/material.dart';

class ComidaContainer extends StatelessWidget {
  const ComidaContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              width: 2.5, color: Theme.of(context).colorScheme.inverseSurface)),
    );
  }
}

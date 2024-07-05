import 'package:flutter/material.dart';

class MyButtonRounded extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String precio;

  const MyButtonRounded({
    super.key,
    required this.text,
    required this.precio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8.0),
              if(precio.isNotEmpty)
                Container(
                  alignment: AlignmentDirectional.center,
                  transformAlignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                      'S/. $precio',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

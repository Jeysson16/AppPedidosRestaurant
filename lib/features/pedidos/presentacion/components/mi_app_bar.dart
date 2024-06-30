import 'package:flutter/material.dart';

class AppBarPedidos extends StatelessWidget {
  const AppBarPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 2.0,
        left: 8.0,
        right: 8.0,
      ),      
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Realiza tu Pedido',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.favorite_outline, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Icon(Icons.notifications_none_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10,)
        ],
      ),
    );
  }
}

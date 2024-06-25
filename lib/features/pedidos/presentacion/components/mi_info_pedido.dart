
import 'package:flutter/material.dart';

class MiInfoPedido extends StatelessWidget {
  const MiInfoPedido({super.key});

  void abrirBuscadorDelivery(BuildContext context) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Tu Ubicación"),
      content: const TextField(
        decoration: InputDecoration(
          hintText: "Buscando ...."),
      ),
      actions: [
        // cancelar
        MaterialButton(onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        // confirmar
        MaterialButton(onPressed: () => Navigator.pop(context),
          child: const Text("Confirmar"),
        )

        // confirmar

      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery",
            style: TextStyle(color: Theme.of(context).colorScheme.primary)
          ),
          GestureDetector(
            onTap: () => abrirBuscadorDelivery(context),
            child: Row(
              children: [
                Text(
                  "Calle Santa Ana #672",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    )
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
            ],),
          )
        ],
      ),
    );
  }
}
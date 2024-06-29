import 'package:flutter/material.dart';
class SliverHeaderData extends StatelessWidget {
  final String cuisine;
  final String horaAtencion;
  final String estado;
  final String telefono;

  const SliverHeaderData({
    Key? key,
    required this.cuisine,
    required this.horaAtencion,
    required this.estado,
    required this.telefono,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            cuisine,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface, // Usa el color adecuado del tema
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                horaAtencion,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface, // Usa el color adecuado del tema
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.circle,
                size: 14,
                color: estado.toLowerCase() == 'abierto' ? Colors.green : Colors.red, // Cambia el color del icono según el estado
              ),
              const SizedBox(width: 4),
              Text(
                estado,
                style: TextStyle(
                  fontSize: 12,
                  color: estado.toLowerCase() == 'abierto' ? Colors.green : Colors.red, // Cambia el color del texto según el estado
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.phone,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                telefono,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface, // Usa el color adecuado del tema
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
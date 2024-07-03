import 'dart:ui';
import 'package:flutter/material.dart';

class PedidoOptionsScreen extends StatelessWidget {
  const PedidoOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    OptionButton(
                      imagePath: 'assets/pide_qr.png',
                      label: 'Pídelo en tu mesa',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PedidoMesaScreen()),
                        );
                      },
                    ),
                    OptionButton(
                      imagePath: 'assets/pide_delivery.png',
                      label: 'Pídelo por delivery',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PedidoDeliveryScreen()),
                        );
                      },
                    ),
                    OptionButton(
                      imagePath: 'assets/pide_reserva.png',
                      label: 'Seleccionar como reserva',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PedidoReservaScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const OptionButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PedidoMesaScreen extends StatelessWidget {
  const PedidoMesaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pídelo en tu mesa'),
      ),
      body: const Center(
        child: Text(
            'Aquí se puede implementar la funcionalidad de escanear el código QR de la mesa.'),
      ),
    );
  }
}

class PedidoDeliveryScreen extends StatelessWidget {
  const PedidoDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pídelo por delivery'),
      ),
      body: const Center(
        child: Text(
            'Aquí se puede implementar la funcionalidad de seleccionar ubicación para delivery.'),
      ),
    );
  }
}

class PedidoReservaScreen extends StatelessWidget {
  const PedidoReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar como reserva'),
      ),
      body: const Center(
        child: Text(
            'Aquí se puede implementar la funcionalidad de realizar una reserva.'),
      ),
    );
  }
}

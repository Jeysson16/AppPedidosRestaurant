import 'package:flutter/material.dart';

class PedidoOptionsScreen extends StatelessWidget {
  const PedidoOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 20),
            OptionButton(
              imagePath: 'assets/pide_delivery.png',
              label: 'Pídelo por delivery',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PedidoDeliveryScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            OptionButton(
              imagePath: 'assets/pide_reserva.png',
              label: 'Seleccionar como reserva',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PedidoReservaScreen()),
                );
              },
            ),
          ],
        ),
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
      body: Center(
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
      body: Center(
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
      body: Center(
        child: Text(
            'Aquí se puede implementar la funcionalidad de realizar una reserva.'),
      ),
    );
  }
}

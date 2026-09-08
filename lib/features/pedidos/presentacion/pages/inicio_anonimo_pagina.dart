import 'package:flutter/material.dart';

class InicioAnonimoPagina extends StatelessWidget {
  const InicioAnonimoPagina({super.key});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFD62828);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.restaurant_menu, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("D' Gilberth", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text('Sabor hecho en brasa', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ])),
              const Icon(Icons.shopping_bag_outlined),
            ]),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF241916), borderRadius: BorderRadius.circular(24)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('HOY EN BRASA', style: TextStyle(color: Color(0xFFFFC85A), fontSize: 12, fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                Text('El sabor que reúne a todos.', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('Haz tu pedido y elige cómo recibirlo.', style: TextStyle(color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 25),
            const Text('Lo más pedido', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 13),
            const _DishCard(icon: Icons.local_fire_department, color: red, name: 'Pollo a la brasa', detail: '1/4 pollo + papas + ensalada', price: 'S/ 18.90'),
            const SizedBox(height: 11),
            const _DishCard(icon: Icons.lunch_dining, color: Color(0xFFFF9D4D), name: 'Parrilla familiar', detail: 'Para compartir · 3 personas', price: 'S/ 54.90'),
            const SizedBox(height: 11),
            const _DishCard(icon: Icons.ramen_dining, color: Color(0xFF7AAE65), name: 'Chaufa especial', detail: 'Pollo, verduras y huevo', price: 'S/ 15.50'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Mis pedidos'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.icon, required this.color, required this.name, required this.detail, required this.price});
  final IconData icon;
  final Color color;
  final String name;
  final String detail;
  final String price;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 6))]),
    child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 4),
        Text(detail, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ])),
      Text(price, style: const TextStyle(fontWeight: FontWeight.w800)),
    ]),
  );
}

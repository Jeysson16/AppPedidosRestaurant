import 'package:flutter/material.dart';

class InicioAnonimoPagina extends StatefulWidget {
  const InicioAnonimoPagina({super.key});

  @override
  _InicioAnonimoPaginaState createState() => _InicioAnonimoPaginaState();
}

class _InicioAnonimoPaginaState extends State<InicioAnonimoPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio Anonimo"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const Drawer(),
    );
  }
}
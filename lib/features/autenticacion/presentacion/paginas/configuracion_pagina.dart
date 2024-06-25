import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/theme/tema.dart';
 
class ConfiguracionPagina extends StatelessWidget {
  
  const ConfiguracionPagina({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuracion'),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)
              ),

              margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Modo Oscuro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary,)),
                  CupertinoSwitch(value: Provider.of<ThemeProvider>(context, listen:false).isDarkMode, onChanged: (value) =>Provider.of<ThemeProvider>(context, listen:false).toggleTheme())
                ]
              ),
            )
          ],
        )
    );
  }
}
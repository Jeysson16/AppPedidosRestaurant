import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/global/view/components/my_button.dart';
import 'package:restaurant_app/app/global/view/components/my_textfield.dart';
import 'package:restaurant_app/app/global/view/components/splash_pagina.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_usuarios_repositorio.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_pagina.dart';
import 'package:restaurant_app/features/menu/pages/menu.dart';

class Entrar extends StatefulWidget {
  final void Function()? onRegisterTap;
  final void Function()? onGuestTap;

  const Entrar({
    super.key,
    required this.onRegisterTap,
    required this.onGuestTap,
  });

  @override
  State<Entrar> createState() => _EntrarState();
}

class _EntrarState extends State<Entrar> {
  // controladores
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAutenticacionRepositorio authService =
      FirebaseAutenticacionRepositorio();

  bool cargando = false;
  void _onIniciarSesion() async {
    // Obtener datos del formulario
    String email = emailController.text.trim();
    String password = passwordController.text;

    // Mostrar splash screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );

    try {
      // Validar que los campos no estén vacíos
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Por favor completa todos los campos.');
      }

      // Llamar a authService para iniciar sesión
      bool esEmpleado = await authService.iniciarSesion(email, password);

      // Quitar el splash screen después de completar la autenticación
      Navigator.pop(context);

      if (esEmpleado) {
        // Redirigir a la pantalla de menú para empleados
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SeleccionarMenuApp()),
        );

      } else {
        // Redirigir a la página de inicio para usuarios normales
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioPagina()),
        );
      }
    } catch (e) {
      // Quitar el splash screen en caso de error
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el inicio de sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/restaurant.png", height: 170),
              const SizedBox(height: 25),
              Text(
                "Restaurant D' Gilberth",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: "Correo Electrónico",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Contraseña",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Iniciar Sesión",
                onTap: _onIniciarSesion,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "¿No tienes una cuenta?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onGuestTap,
                        child: Text(
                          "Ingresar sin cuenta",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onRegisterTap,
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

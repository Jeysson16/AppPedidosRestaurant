import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/global/view/components/my_button.dart';
import 'package:restaurant_app/app/global/view/components/my_textfield.dart';
import 'package:restaurant_app/app/global/view/components/splash_pagina.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_usuarios_repositorio.dart';
import 'package:restaurant_app/features/auth/data/service/dni_service_repositorio.dart';
import 'package:restaurant_app/features/auth/dominio/casos_uso/usuario/registrar_usuario.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_pagina.dart';

class RegistrarUsuarioPagina extends StatefulWidget {
  final void Function()? onTap;
  const RegistrarUsuarioPagina({super.key, required this.onTap});

  @override
  _RegistrarUsuarioPaginaState createState() => _RegistrarUsuarioPaginaState();
}

class _RegistrarUsuarioPaginaState extends State<RegistrarUsuarioPagina> {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Instancia de PreferenciasUsuario
  final PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();

  late final registrarUsuarioCaso = RegistrarUsuarioCaso(
    dniService:
        DniService(), // Reemplaza con la implementación real de IDniService
    authRepository:
        FirebaseAutenticacionRepositorio(), // Reemplaza con la implementación real de IAuthRepository
  );

  void _onRegistrarse() async {
    // Obtener datos del formulario
    String dni = dniController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    // Mostrar splash screen
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que se pueda cerrar tocando fuera del splash
      builder: (BuildContext context) {
        return const SplashScreen();
      },
    );
    try {
      // Llamar al caso de uso para registrar usuario
      await registrarUsuarioCaso.ejecutarRegistro(dni, email, password);

      // Ocultar splash screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Cierra el splash screen

      // Navegar a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InicioPagina()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el registro: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/restaurant.png', height: 170),

              const SizedBox(height: 25),

              // Slogan
              Text(
                "¡Crea tu cuenta en Restaurant D' Gilberth!",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // DNI
              MyTextField(
                  controller: dniController,
                  hintText: "Documento de Identidad",
                  obscureText: false),

              const SizedBox(height: 10),

              // Email
              MyTextField(
                  controller: emailController,
                  hintText: "Correo Electrónico",
                  obscureText: false),

              const SizedBox(height: 10),

              // Contraseña
              MyTextField(
                  controller: passwordController,
                  hintText: "Contraseña",
                  obscureText: true),

              const SizedBox(height: 10),

              // Confirmar Contraseña
              MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirmar Contraseña",
                  obscureText: true),

              const SizedBox(height: 25),

              // Botón Registrarse
              MyButton(text: "Registrarse", onTap: _onRegistrarse),

              const SizedBox(height: 20),

              // Iniciar sesión con cuenta existente
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿Ya tienes una cuenta?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Inicia sesión",
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/view/components/my_button.dart';
import 'package:restaurant_app/app/global/view/components/my_textfield.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_empleado_repositorio.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_pagina.dart';

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
  final FirebaseAutenticacionRepositorio authService = FirebaseAutenticacionRepositorio();
  bool cargando = false;

  // iniciar sesion
  void iniciar() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const InicioPagina())
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // para un poco de padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Image.asset(height: 170, "assets/restaurant.png"),
              
              const SizedBox(height: 25),
              //slogan
              Text(
                "Restaurant D' Gilberth",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 25),
              //email
              MyTextField(controller: emailController, hintText: "Correo Electronico", obscureText: false),

              const SizedBox(height: 10),
              
              //contraseña
              MyTextField(controller: passwordController, hintText: "Contraseña", obscureText: true),

              const SizedBox(height: 25),
              //boton iniciar sesion
              MyButton(
                text: "Iniciar Sesión",
                onTap: iniciar,
              ),

              const SizedBox(height: 20),
              //registrarse y ingresar sin cuenta
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

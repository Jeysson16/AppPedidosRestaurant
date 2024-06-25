import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/view/components/my_button.dart';
import 'package:restaurant_app/app/global/view/components/my_textfield.dart';

class RegistrarUsuarioPagina extends StatefulWidget {
  final void Function()? onTap;
  const RegistrarUsuarioPagina({super.key, required this.onTap});

  @override
  State<RegistrarUsuarioPagina> createState() => _RegistrarUsuarioPaginaState();
}

class _RegistrarUsuarioPaginaState extends State<RegistrarUsuarioPagina> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Image.asset(height: 170, "assets/restaurant.png"),
            
            const SizedBox(height: 25),
            //slogan
            Text(
              "¡Crea tu cuenta en Restaurant D' Gilberth!",
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

            const SizedBox(height: 10),
            
            //contraseña
            MyTextField(controller: confirmPasswordController, hintText: "Confirmar Contraseña", obscureText: true),

            const SizedBox(height: 25),
            //boton iniciar sesion
            MyButton(text:"Registrarse", onTap: (){}),

            const SizedBox(height: 20),
            
            //Iniciar sesion con cuenta
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
    );
  }
}
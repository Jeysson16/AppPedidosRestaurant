import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_cargo.repositorio.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_usuarios_repositorio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/cargo.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_bloc.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_event.dart';

class RegistrarEmpleadoPagina extends StatefulWidget {
  static const routeName = '/registrar-empleado';

  const RegistrarEmpleadoPagina({Key? key}) : super(key: key);

  @override
  _RegistrarEmpleadoPaginaState createState() =>
      _RegistrarEmpleadoPaginaState();
}

class _RegistrarEmpleadoPaginaState extends State<RegistrarEmpleadoPagina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseCargoRepository _cargoRepository = FirebaseCargoRepository();
  final FirebaseAutenticacionRepositorio _authRepository =
      FirebaseAutenticacionRepositorio(); // Tu repositorio de autenticación

  String? _nombre;
  String? _dni;
  String? _edad;
  String? _selectedCargo;
  String? _sucursalId;
  List<Cargo> _cargos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSucursalId();
  }

  Future<void> _loadSucursalId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sucursalId = prefs.getString('sucursalId');
    });
    if (_sucursalId != null) {
      await _loadCargos();
    }
  }

  Future<void> _loadCargos() async {
    try {
      final cargos = await _cargoRepository.buscarTodosLosCargos(_sucursalId!);
      setState(() {
        _cargos = cargos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Guarda los valores del formulario

      // Construye el mapa de datos del empleado
      Map<String, dynamic> empleadoData = {
        'nombre': _nombre,
        'dni': _dni,
        'edad': _edad,
        'sucursal': _sucursalId,
        'cargo': _selectedCargo,
      };

      try {
        // Llama al método del repositorio para registrar el empleado
        await _authRepository.registrarEmpleado(
          emailController.text,
          passwordController.text,
          empleadoData,
        );

        // Si el registro es exitoso, muestra un mensaje o navega a otra pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado registrado correctamente')),
        );
        emailController.clear();
        passwordController.clear();
        setState(() {
          emailController.clear();
          passwordController.clear();
          _nombre = null;
          _dni = null;
          _edad = null;
          _selectedCargo = null;
        });
        _formKey.currentState?.reset(); // Reinicia el estado del formulario
      } catch (e) {
        // Maneja cualquier error que pueda ocurrir durante el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar empleado: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Nuevos Empleados')),
      body: _buildForm(_cargos),
    );
  }

  Widget _buildForm(List<Cargo> cargos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su correo electrónico';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su nombre';
                }
                return null;
              },
              onSaved: (value) => _nombre = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Documento de Identidad (DNI)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su DNI';
                }
                return null;
              },
              onSaved: (value) => _dni = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su edad';
                }
                return null;
              },
              onSaved: (value) => _edad = value,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCargo,
              hint: const Text('Seleccione un cargo'),
              items: cargos.map<DropdownMenuItem<String>>((Cargo cargo) {
                return DropdownMenuItem<String>(
                  value: cargo.id,
                  child: Text(cargo.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  print(value);
                  _selectedCargo = value;
                  print(value);
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Agregar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

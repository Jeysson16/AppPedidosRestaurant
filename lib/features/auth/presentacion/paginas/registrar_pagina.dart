import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/global/view/components/cargando_pagina.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/cargo.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_bloc.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_event.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_state.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/sucursal_cargo_bloc.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/sucursal_cargo_event.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/sucursal_cargo_state.dart';

class RegistrarEmpleadoPagina extends StatefulWidget {
  static const routeName = '/registrar-empleado';
  const RegistrarEmpleadoPagina({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrarEmpleadoPaginaState createState() => _RegistrarEmpleadoPaginaState();
}

class _RegistrarEmpleadoPaginaState extends State<RegistrarEmpleadoPagina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _nombre;
  String? _celular;
  String? _clave;
  String? _dni;
  String? _edad;
  String? _selectedSucursalId;
  String? _selectedCargo;

  @override
  void initState() {
    super.initState();
    context.read<SucursalCargoBloc>().add(LoadSucursalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Nuevos Empleados')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomLoadingPage()),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context); // Quitar la pantalla de carga
            Navigator.pop(context); // Regresar a la pantalla anterior
          } else if (state is AuthFailure) {
            Navigator.pop(context); // Quitar la pantalla de carga
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<SucursalCargoBloc, SucursalCargoState>(
          builder: (context, state) {
            if (state is SucursalCargoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SucursalesLoaded) {
              return _buildForm(state.sucursales);
            } else if (state is SucursalCargoFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildForm(List<Sucursal> sucursales) {
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
              value: _selectedSucursalId,
              hint: const Text('Seleccione una sucursal'),
              items: sucursales.map<DropdownMenuItem<String>>((Sucursal sucursal) {
                return DropdownMenuItem<String>(
                  value: sucursal.id,
                  child: Text(sucursal.nombreSucursal),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSucursalId = value;
                  _selectedCargo = null; // Reiniciar la selección de cargo
                });
                if (_selectedSucursalId != null) {
                  context.read<SucursalCargoBloc>().add(LoadCargosEvent(_selectedSucursalId!));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione una sucursal';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<SucursalCargoBloc, SucursalCargoState>(
              builder: (context, state) {
                if (state is CargosLoaded) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCargo,
                    hint: const Text('Seleccione un cargo'),
                    items: state.cargos.map<DropdownMenuItem<String>>((Cargo cargo) {
                      return DropdownMenuItem<String>(
                        value: cargo.id,
                        child: Text(cargo.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCargo = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor seleccione un cargo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
                            child: const Text('Agregar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlocProvider.of<AuthBloc>(context).add(
        RegistrarEmpleadoEvent(
          emailController.text,
          passwordController.text,
          {
            'nombre': _nombre,
            'celular': _celular,
            'clave': _clave,
            'dni': _dni,
            'edad': _edad,
            'sucursal': _selectedSucursalId,
            'cargo': _selectedCargo,
          },
        ),
      );
    }
  }
}

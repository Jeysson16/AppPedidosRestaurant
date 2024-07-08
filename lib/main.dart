import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/theme/tema.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/autenticacion_bloc.dart';
import 'package:restaurant_app/features/auth/presentacion/paginas/ingresar_o_registrar.dart';
import 'package:restaurant_app/features/pedidos/data/repositorios/mapbox_ubicacion_repository.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/buscar_ubicacion_manual.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/calcular_cobro.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/calcular_distancia.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/calcular_tiempo_caminando.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/calcular_tiempo_moto.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/establecer_modo.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/guardar_ubicacion.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/obtener_modo_tema.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/obtener_sugerencias_ubicacion.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/obtener_ubicacion_sucursales.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/obtener_ubicacion_tiempo_real.dart';
import 'package:restaurant_app/features/pedidos/dominio/casos_uso/obtener_url_template.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferenciasUsuario.init();
  final ubicacionRepositorio = UbicacionRepositorioImpl(
    mapboxToken: "pk.eyJ1IjoiamV5c3NvbjM2IiwiYSI6ImNseG92MXl3MTBiOTUya3B3cjV2NngyMWsifQ.x8I5goP1hAQwWME3obHsZg",
    firestore: FirebaseFirestore.instance,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PresentacionPedidosBloc()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      BlocProvider(create: (context) => UbicacionBloc(
        obtenerUbicacionesSucursales: ObtenerUbicacionesSucursales(ubicacionRepositorio),
        obtenerUbicacionTiempoReal: ObtenerUbicacionTiempoReal(ubicacionRepositorio),
        guardarUbicacion: GuardarUbicacion(ubicacionRepositorio),
        buscarUbicacionManual: BuscarUbicacionManual(ubicacionRepositorio),
        calcularDistancia: CalcularDistancia(ubicacionRepositorio),
        calcularTiempoCaminando: CalcularTiempoCaminando(ubicacionRepositorio),
        calcularTiempoMoto: CalcularTiempoMoto(ubicacionRepositorio),
        calcularCobro: CalcularCobro(ubicacionRepositorio),
        establecerModoTema: EstablecerModoTema(ubicacionRepositorio),
        obtenerModoTema: ObtenerModoTema(ubicacionRepositorio),
        obtenerUrlTemplate: ObtenerUrlTemplate(ubicacionRepositorio), 
        obtenerSugerencias: ObtenerSugerenciasUbicacion(ubicacionRepositorio),
      )..add(ObtenerModoTemaEvent())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IngresarORegistrar(),
      title: 'Restaurant D Gilberth',
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/buscar_ubicacion_manual.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/calcular_cobro.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/calcular_distancia.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/calcular_tiempo_caminando.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/calcular_tiempo_moto.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/establecer_modo.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/guardar_ubicacion.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/obtener_sugerencias_ubicacion.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/obtener_ubicacion_sucursales.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/obtener_ubicacion_tiempo_real.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/obtener_modo_tema.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/casos_uso/obtener_url_template.dart';
import 'ubicacion_event.dart';
import 'ubicacion_state.dart';

class UbicacionBloc extends Bloc<UbicacionEvent, UbicacionState> {
  final ObtenerUbicacionesSucursales obtenerUbicacionesSucursales;
  final ObtenerUbicacionTiempoReal obtenerUbicacionTiempoReal;
  final GuardarUbicacion guardarUbicacion;
  final BuscarUbicacionManual buscarUbicacionManual;
  final CalcularDistancia calcularDistancia;
  final CalcularTiempoCaminando calcularTiempoCaminando;
  final CalcularTiempoMoto calcularTiempoMoto;
  final CalcularCobro calcularCobro;
  final EstablecerModoTema establecerModoTema;
  final ObtenerModoTema obtenerModoTema;
  final ObtenerUrlTemplate obtenerUrlTemplate;
  final ObtenerSugerenciasUbicacion obtenerSugerencias;

  UbicacionBloc({
    required this.obtenerUbicacionesSucursales,
    required this.obtenerUbicacionTiempoReal,
    required this.guardarUbicacion,
    required this.buscarUbicacionManual,
    required this.calcularDistancia,
    required this.calcularTiempoCaminando,
    required this.calcularTiempoMoto,
    required this.calcularCobro,
    required this.establecerModoTema,
    required this.obtenerModoTema,
    required this.obtenerUrlTemplate,
    required this.obtenerSugerencias
  }) : super(UbicacionInitial()) {
    on<ObtenerUrlTemplateEvent>(_onObtenerUrlTemplateEvent);
    on<ObtenerUbicacionSucursalesEvent>(_onObtenerUbicacionSucursalesEvent);
    on<ObtenerUbicacionTiempoRealEvent>(_onObtenerUbicacionTiempoRealEvent);
    on<GuardarUbicacionEvent>(_onGuardarUbicacionEvent);
    on<BuscarUbicacionManualEvent>(_onBuscarUbicacionManualEvent);
    on<CalcularDistanciaEvent>(_onCalcularDistanciaEvent);
    on<CalcularTiempoCaminandoEvent>(_onCalcularTiempoCaminandoEvent);
    on<CalcularTiempoMotoEvent>(_onCalcularTiempoMotoEvent);
    on<CalcularCobroEvent>(_onCalcularCobroEvent);
    on<EstablecerModoTemaEvent>(_onEstablecerModoTemaEvent);
    on<ObtenerModoTemaEvent>(_onObtenerModoTemaEvent);
    on<ObtenerSugerenciasEvent>(_onObtenerSugerenciasEvent);
  }

  void _onObtenerUbicacionSucursalesEvent(
    ObtenerUbicacionSucursalesEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final sucursales = await obtenerUbicacionesSucursales();
      emit(SucursalesLoaded(sucursales));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onObtenerUbicacionTiempoRealEvent(
    ObtenerUbicacionTiempoRealEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final ubicacion = await obtenerUbicacionTiempoReal();
      emit(UbicacionTiempoRealLoaded(ubicacion));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onGuardarUbicacionEvent(
    GuardarUbicacionEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      await guardarUbicacion(event.ubicacion);
      emit(UbicacionGuardada());
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onCalcularDistanciaEvent(
    CalcularDistanciaEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final distancia = calcularDistancia(event.origen, event.destino);
      final costoDelivery = calcularCobro(calcularTiempoMoto(distancia));
      emit(DistanciaCalculada(distancia, costoDelivery));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onCalcularTiempoCaminandoEvent(
    CalcularTiempoCaminandoEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final tiempo = calcularTiempoCaminando(event.distancia);
      emit(TiempoCaminandoCalculado(tiempo));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onCalcularTiempoMotoEvent(
    CalcularTiempoMotoEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final tiempo = calcularTiempoMoto(event.distancia);
      emit(TiempoMotoCalculado(tiempo));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onCalcularCobroEvent(
    CalcularCobroEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final cobro = calcularCobro(event.tiempoMoto);
      emit(CobroCalculado(cobro));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onEstablecerModoTemaEvent(
    EstablecerModoTemaEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      await establecerModoTema(event.modoTema);
      emit(ModoTemaEstablecido(event.modoTema));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onObtenerUrlTemplateEvent(
    ObtenerUrlTemplateEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final urlTemplate = obtenerUrlTemplate(event.modoTema);
      emit(UrlTemplateObtenido(urlTemplate));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }
  void _onObtenerModoTemaEvent(
    ObtenerModoTemaEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final modoTema = await obtenerModoTema();
      emit(ModoTemaObtenido(modoTema));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onObtenerSugerenciasEvent(
    ObtenerSugerenciasEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final sugerencias = await obtenerSugerencias(event.query);
      emit(SugerenciasLoaded(sugerencias));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }

  void _onBuscarUbicacionManualEvent(
    BuscarUbicacionManualEvent event,
    Emitter<UbicacionState> emit,
  ) async {
    emit(UbicacionLoading());
    try {
      final ubicacion = await buscarUbicacionManual(event.direccion);
      emit(UbicacionManualLoaded(ubicacion));
    } catch (e) {
      emit(UbicacionError(e.toString()));
    }
  }
  
}
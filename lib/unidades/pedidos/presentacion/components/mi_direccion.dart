import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurant_app/unidades/pedidos/presentacion/bloc/ubicacion_bloc.dart';
import 'package:restaurant_app/unidades/pedidos/presentacion/bloc/ubicacion_event.dart';
import 'package:restaurant_app/unidades/pedidos/presentacion/bloc/ubicacion_state.dart';
import 'package:restaurant_app/unidades/pedidos/presentacion/components/mi_ubicacion_marker.dart';

const mapboxToken = "pk.eyJ1IjoiamV5c3NvbjM2IiwiYSI6ImNseG92MXl3MTBiOTUya3B3cjV2NngyMWsifQ.x8I5goP1hAQwWME3obHsZg";
const markerColor = Color(0xFFED1113);
const _miUbicacion = LatLng(-8.077511514344646, -78.9964878591555);

class MiUbicacion extends StatefulWidget {
  const MiUbicacion({super.key});

  @override
  State<MiUbicacion> createState() => _MiUbicacionState();
}


class _MiUbicacionState extends State<MiUbicacion> {
  LatLng? _selectedLocation;
  late UbicacionBloc _ubicacionBloc;
  String _urlTemplate = '';
  late TextEditingController _searchController;
  late Marker _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _ubicacionBloc = BlocProvider.of<UbicacionBloc>(context);
    _searchController = TextEditingController();
    _ubicacionBloc.add(ObtenerUbicacionSucursalesEvent());
    _ubicacionBloc.add(ObtenerUbicacionTiempoRealEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modoTema = Theme.of(context).brightness == Brightness.dark ? "oscuro" : "claro";
    _ubicacionBloc.add(ObtenerUrlTemplateEvent(modoTema));
  }

  void _onSuggestionSelected() {
    final direccion = _searchController.text;
    if (direccion.isNotEmpty) {
      _ubicacionBloc.add(BuscarUbicacionManualEvent(direccion));
    }
    _searchController.text = direccion;
    Navigator.of(context).pop();
  }

  void _updateSelectedLocation(Position position) {
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _currentLocationMarker = Marker(
        point: _selectedLocation!,
        width: 30,
        height: 30,
        child: const MiUbicacionMarker(),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi ubicación"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Buscar dirección"),
                  content: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TypeAheadField<String>(                        
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        suggestionsCallback: (pattern) async {
                          _ubicacionBloc.add(ObtenerSugerenciasEvent(pattern));
                          final state = await _ubicacionBloc.stream.firstWhere((state) => state is SugerenciasLoaded || state is UbicacionError);
                          if (state is SugerenciasLoaded) {
                            return state.sugerencias;
                          } else {
                            return [];
                          }
                        },
                        loadingBuilder: (context) => const CircularProgressIndicator(),
                        errorBuilder: (context, error) => const Text('Error!'),
                        emptyBuilder: (context) => const Text('No se encontró la dirección. Busca con alguna referencia'),                    
                        onSelected: (suggestion) {
                          _onSuggestionSelected();
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UbicacionBloc, UbicacionState>(
        builder: (context, state) {
          List<Marker> markers = [];
          if (state is UbicacionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SucursalesLoaded) {
            final sucursales = state.sucursales;
            markers = sucursales.map((sucursal) {
              return Marker(
                point: LatLng(sucursal.latitude, sucursal.longitude),
                width: 20,
                height: 20,
                child: const Image(image: AssetImage("assets/marker.png")),
              );
            }).toList();
            if (_selectedLocation != null) {
              markers.add(_currentLocationMarker);
            }
          } else if (state is UbicacionManualLoaded) {
            _updateSelectedLocation(Position(
              latitude: state.ubicacion.latitude,
              longitude: state.ubicacion.longitude,
              timestamp: DateTime.now(),
              accuracy: 1.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 1.0,
              altitudeAccuracy: 1.0,
              headingAccuracy: 1.0,
            ));
            markers.add(_currentLocationMarker);
          } else if (state is UrlTemplateObtenido) {
            _urlTemplate = state.urlTemplate;
          } else if (state is UbicacionError) {
            return Center(child: Text(state.mensaje));
          }

          return FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 16,
              initialCenter: _selectedLocation ?? _miUbicacion,
              initialZoom: 10,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              MarkerLayer(
                markers: markers,
              ),
              TileLayer(
                urlTemplate: _urlTemplate,
                additionalOptions: const {
                  'accessToken': mapboxToken,
                  'id': 'mapbox.streets',
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurant_app/features/pedidos/data/model/calle_sugerencias.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_event.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_state.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_ubicacion_marker.dart';

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
  final MapController _mapController = MapController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _ubicacionBloc = BlocProvider.of<UbicacionBloc>(context);
    _searchController = TextEditingController();
    _ubicacionBloc.add(ObtenerUbicacionSucursalesEvent());
    _ubicacionBloc.add(ObtenerUbicacionTiempoRealEvent());

    _currentLocationMarker = const Marker(
      point: _miUbicacion, // Inicializamos con una ubicación predeterminada
      width: 30,
      height: 30,
      child: MiUbicacionMarker(),
    );
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

  void _onSuggestionSelected(AddressSuggestion suggestion) {
    _ubicacionBloc.add(BuscarUbicacionManualEvent(suggestion.fullAddress));
    _searchController.text = suggestion.fullAddress;
    setState(() {
      _selectedLocation = LatLng(suggestion.latitude, suggestion.longitude);
      _isSearching = false;
    });
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: _isSearching
                ? TypeAheadField<AddressSuggestion>(
                    controller: _searchController,
                    builder: (context, controller, focusNode){
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Buscar dirección...',
                          border: InputBorder.none,
                        ),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      _ubicacionBloc.add(ObtenerSugerenciasEvent(pattern));
                      final state = await _ubicacionBloc.stream.firstWhere(
                          (state) =>
                              state is SugerenciasLoaded ||
                              state is UbicacionError);
                      if (state is SugerenciasLoaded) {
                        return state.sugerencias;
                      } else {
                        return [];
                      }
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${translateFeatureType(suggestion.descripcion)}: ${suggestion.fullAddress}'),
                        subtitle: Text(suggestion.descripcion),
                      );
                    },
                    onSelected: (suggestion) {
                      _onSuggestionSelected(suggestion);
                    },
                    loadingBuilder: (context) =>
                        const CircularProgressIndicator(),
                    errorBuilder: (context, error) => const Text('Error!'),
                    emptyBuilder: (context) => const Text(
                            'No se encontró la dirección. Busca con alguna referencia'),
                  )
                : const Text('Mi ubicación'),
            actions: [
              if (!_isSearching)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              if (_isSearching)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                    });
                  },
                ),
            ],
          ),
          SliverFillRemaining(
            child: BlocBuilder<UbicacionBloc, UbicacionState>(
              builder: (context, state) {
                List<Marker> markers = [];

                if (state is UbicacionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SucursalesLoaded) {
                  final sucursales = state.sucursales;
                  markers = sucursales.map((sucursal) {
                    return Marker(
                      point: LatLng(sucursal.ubicacion.latitude, sucursal.ubicacion.longitude),
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

                // Agregar un marcador de prueba estático para depuración
                markers.add(const Marker(
                  point: _miUbicacion,
                  width: 20,
                  height: 20,
                  child: MiUbicacionMarker(),
                ));
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    minZoom: 5,
                    maxZoom: 18,
                    initialCenter: _selectedLocation ?? _miUbicacion,
                    initialZoom: 16,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLocation = point;
                        _currentLocationMarker = Marker(
                          point: _selectedLocation!,
                          width: 30,
                          height: 30,
                          child: const MiUbicacionMarker(),
                        );
                        markers.add(_currentLocationMarker);
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: _urlTemplate,
                      additionalOptions: const {
                        'accessToken': mapboxToken,
                        'id': 'mapbox.streets',
                      },
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  
  String translateFeatureType(String featureType) {
  switch (featureType) {
    case 'country':
      return 'País';
    case 'address':
      return 'Dirección';
    case 'secondary_address':
      return 'Dirección secundaria';
    case 'street':
      return 'Calle';
    case 'postcode':
      return 'Código postal';
    case 'neighborhood':
      return 'Barrio';
    case 'place':
      return 'Lugar';
    case 'locality':
      return 'Localidad';
    case 'region':
      return 'Región';
    case 'district':
      return 'Distrito';
    default:
      return featureType;
  }
}

}

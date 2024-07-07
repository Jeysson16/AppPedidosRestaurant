import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/pedidos/data/model/calle_sugerencias.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_event.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/ubicacion_state.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_ubicacion_marker.dart';

const mapboxToken =
    "pk.eyJ1IjoiamV5c3NvbjM2IiwiYSI6ImNseG92MXl3MTBiOTUya3B3cjV2NngyMWsifQ.x8I5goP1hAQwWME3obHsZg";

LatLng _miUbicacion = LatLng(-8.077511514344646, -78.9964878591555);

class MiUbicacion extends StatefulWidget {
  const MiUbicacion({Key? key}) : super(key: key);

  @override
  State<MiUbicacion> createState() => _MiUbicacionState();
}

class _MiUbicacionState extends State<MiUbicacion> {
  LatLng? _ubiSucursal;
  final LayerHitNotifier hitNotifier = ValueNotifier(null);
  LatLng? _selectedLocation;
  late UbicacionBloc _ubicacionBloc;
  String _urlTemplate = '';
  late TextEditingController _searchController;
  final MapController _mapController = MapController();
  bool _isSearching = false;
  List<Marker> _markers = [];
  List<Polyline> _polyline = [];

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
    final modoTema =
        Theme.of(context).brightness == Brightness.dark ? "oscuro" : "claro";
    _ubicacionBloc.add(ObtenerUrlTemplateEvent(modoTema));
  }

  void _onSuggestionSelected(AddressSuggestion suggestion) {
    _ubicacionBloc.add(BuscarUbicacionManualEvent(suggestion.fullAddress));
    _searchController.text = suggestion.fullAddress;
    setState(() {
      _selectedLocation = LatLng(suggestion.latitude, suggestion.longitude);
      _isSearching = false;
      _miUbicacion = _selectedLocation!;
    });
  }

  List<Polyline> _buildPolylines() {
    final List<Polyline> polylines = [];

    if (_selectedLocation != null && _ubiSucursal != null) {
      final List<LatLng> polylinePoints = [_miUbicacion, _ubiSucursal!];

      polylines.add(
        Polyline(
          points: polylinePoints,
          useStrokeWidthInMeter: true,
          pattern: StrokePattern.dotted(),
          strokeJoin: StrokeJoin.bevel,
          strokeCap: StrokeCap.round,
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 3.0,
        ),
      );
    }

    return polylines;
  }

  List<Marker> buildMarkers(List<Sucursal> sucursales) {
    final markerList = <Marker>[];
    for (final sucursal in sucursales) {
      final geoPoint = sucursal.ubicacion as GeoPoint;
      final latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
      final List<LatLng> polylinePoints = [_miUbicacion, latLng];

      markerList.add(Marker(
        height: 45,
        width: 45,
        point: latLng,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _ubiSucursal = latLng; // Actualiza el punto seleccionado
              _polyline = _buildPolylines(); // Actualiza el Polyline
            });
          },
          child: Image.asset(
            'assets/marker.png',
          ),
        ),
      ));
    }
    return markerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: _isSearching
                    ? TypeAheadField<AddressSuggestion>(
                        controller: _searchController,
                        builder: (context, controller, focusNode) {
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
                            title: Text(
                                '${translateFeatureType(suggestion.descripcion)}: ${suggestion.fullAddress}'),
                            subtitle: Text(suggestion.descripcion),
                          );
                        },
                        onSelected: (suggestion) {
                          _onSuggestionSelected(suggestion);
                          _mapController.move(_miUbicacion, 16.0);
                        },
                        loadingBuilder: (context) =>
                            const CircularProgressIndicator(),
                        errorBuilder: (context, error) => const Text('Error!'),
                        emptyBuilder: (context) => const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Busca con alguna referencia'),
                        ),
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
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Lógica para manejar el botón "Siguiente"
                      // Puedes navegar a la siguiente pantalla u otra acción
                    },
                  ),
                ],
              ),
              SliverFillRemaining(
                child: BlocBuilder<UbicacionBloc, UbicacionState>(
                  builder: (context, state) {
                    if (state is UbicacionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SucursalesLoaded) {
                      final sucursales = state.sucursales;
                      _markers = buildMarkers(sucursales);
                      if (_selectedLocation != null) {
                        _miUbicacion = _selectedLocation!;

                        _mapController.move(_miUbicacion, 18.0);
                      }
                    } else if (state is UrlTemplateObtenido) {
                      _urlTemplate = state.urlTemplate;
                    } else if (state is UbicacionError) {
                      return Center(child: Text(state.mensaje));
                    }

                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        minZoom: 5,
                        maxZoom: 18,
                        initialCenter: _selectedLocation ?? _miUbicacion,
                        initialZoom: 14,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedLocation = point;
                            _miUbicacion = _selectedLocation!;
                            _polyline =
                                _buildPolylines(); // Actualiza el Polyline
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
                        MarkerLayer(markers: _markers),
                        PolylineLayer(polylines: _polyline),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _miUbicacion,
                              width: 40,
                              height: 40,
                              child: const MiUbicacionMarker(),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
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

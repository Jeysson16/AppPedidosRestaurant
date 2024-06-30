import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/global/view/components/my_drawer.dart';
import 'package:restaurant_app/features/mesa/data/repositorios/firebase_sucursal_repositorio.dart';
import 'package:restaurant_app/features/mesa/presentacion/bloc/sucursal_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_app_bar.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_banner_repositorio.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_bloc.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/home_sliver.dart';

const carritoBarraNavegacion = 60.0;
const expandedHeight = 0.85; // 60% of the screen height

class InicioPagina extends StatefulWidget {
  const InicioPagina({super.key});

  @override
  State<InicioPagina> createState() => _InicioPaginaState();
}

class _InicioPaginaState extends State<InicioPagina> with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _showAppBar = ValueNotifier(true);
  late SliverScrollController _sliverScrollController;
  final bloc = PresentacionPedidosBloc();
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  double _currentHeight = carritoBarraNavegacion;

  @override
  void initState() {
    super.initState();
    _sliverScrollController = SliverScrollController(
      CategoriaProductosRepositoryImpl(firestore: FirebaseFirestore.instance),
      BannerRepositorioImpl(firestore: FirebaseFirestore.instance),
    );
    _sliverScrollController.scrollControllerGlobally.addListener(_scrollListener);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: carritoBarraNavegacion,
      end: MediaQuery.of(context).size.height * expandedHeight,
    ).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation = Tween<double>(
      begin: carritoBarraNavegacion,
      end: MediaQuery.of(context).size.height * expandedHeight,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _sliverScrollController.scrollControllerGlobally.removeListener(_scrollListener);
    _sliverScrollController.dispose();
    _showAppBar.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_sliverScrollController.scrollControllerGlobally.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showAppBar.value) {
        _showAppBar.value = false;
      }
    } else if (_sliverScrollController.scrollControllerGlobally.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showAppBar.value && _sliverScrollController.scrollControllerGlobally.position.pixels <= 0) {
        _showAppBar.value = true;
      }
    }
  }

  void movimientoVerticalCarrito(DragUpdateDetails details) {
    setState(() {
      _currentHeight -= details.primaryDelta!;
      _currentHeight = _currentHeight.clamp(carritoBarraNavegacion, MediaQuery.of(context).size.height * expandedHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    final sucursalRepository = SucursalRepositoryImpl(firestoreInstance);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SucursalBloc(sucursalRepository)..add(LoadSucursales()),
        ),
        BlocProvider(
          create: (context) => ProductosBloc(CategoriaProductosRepositoryImpl(firestore: firestoreInstance)),
        ),
      ],
      child: Scaffold(
        drawer: const MyDrawer(),
        body: GestureDetector(
          onVerticalDragUpdate: movimientoVerticalCarrito,
          child: Stack(
            children: [
              Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _showAppBar,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: value ? kToolbarHeight + 10 : 0,
                        child: value ? const AppBarPedidos() : null,
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<SucursalBloc, SucursalState>(
                      builder: (context, sucursalState) {
                        if (sucursalState is SucursalLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (sucursalState is SucursalLoaded) {
                          final sucursales = sucursalState.sucursales;
                          if (sucursales.isEmpty) {
                            return const Center(child: Text('No hay sucursales disponibles'));
                          }
                          return VistaProductos(
                            bloc: _sliverScrollController,
                            sucursales: sucursales,
                          );
                        } else if (sucursalState is SucursalError) {
                          return Center(child: Text(sucursalState.message));
                        }
                        return const Center(child: Text('No hay sucursales disponibles'));
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _currentHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Theme.of(context).colorScheme.inverseSurface,
                    child: Center(
                      child: Text(
                        _getTextForState(bloc.presentacionState),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTextForState(PresentacionPedidoState state) {
    switch (state) {
      case PresentacionPedidoState.normal:
        return 'Carrito';
      case PresentacionPedidoState.details:
        return 'Detalles';
      case PresentacionPedidoState.cart:
        return 'Carrito';
      default:
        return 'Carrito';
    }
  }
}
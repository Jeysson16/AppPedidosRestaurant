import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/global/view/components/my_drawer.dart';
import 'package:restaurant_app/features/mesa/data/repositorios/firebase_sucursal_repositorio.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/presentacion/components/carrito_empleado.dart';
import 'package:restaurant_app/features/mesa/presentacion/pages/general_productos.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_app_bar.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_banner_repositorio.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_bloc.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';

const carritoBarraNavegacion = 80.0;
const expandedHeight = 0.85;

class ListadoProductos extends StatefulWidget {
  const ListadoProductos({super.key});

  @override
  State<ListadoProductos> createState() => _ListadoProductosState();
}

class _ListadoProductosState extends State<ListadoProductos>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _showAppBar = ValueNotifier(true);
  late SliverScrollController _sliverScrollController;
  late PresentacionPedidosBloc bloc;
  late AnimationController _animationController;
  double _currentHeight = carritoBarraNavegacion;
  final double targetExpandedHeight = 500.0;
  final double targetCollapsedHeight = 80.0;
  late Future<Sucursal?> ubicacionFuture;

  @override
  void initState() {
    super.initState();
    _sliverScrollController = SliverScrollController(
      CategoriaProductosRepositoryImpl(firestore: FirebaseFirestore.instance),
      BannerRepositorioImpl(firestore: FirebaseFirestore.instance),
    );
    _sliverScrollController.scrollControllerGlobally
        .addListener(_scrollListener);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    PreferenciasUsuario.init();
    ubicacionFuture = obtenerSucursal();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = Provider.of<PresentacionPedidosBloc>(context, listen: false);

    // Añadir listener para el carrito
    bloc.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    setState(() {}); // Actualizar la interfaz cuando cambia el carrito
  }

  @override
  void dispose() {
    _sliverScrollController.scrollControllerGlobally
        .removeListener(_scrollListener);
    _sliverScrollController.dispose();
    _showAppBar.dispose();
    _animationController.dispose();
    bloc.removeListener(_onCartChanged);
    super.dispose();
  }

  void _scrollListener() {
    if (_sliverScrollController
            .scrollControllerGlobally.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showAppBar.value) {
        _showAppBar.value = false;
      }
    } else if (_sliverScrollController
            .scrollControllerGlobally.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showAppBar.value &&
          _sliverScrollController.scrollControllerGlobally.position.pixels <=
              0) {
        _showAppBar.value = true;
      }
    }
  }

  void movimientoVerticalCarrito(DragUpdateDetails details) {
    setState(() {
      _currentHeight -= details.primaryDelta!;
      _currentHeight = _currentHeight.clamp(carritoBarraNavegacion,
          MediaQuery.of(context).size.height * expandedHeight);
    });

    if (_currentHeight >= MediaQuery.of(context).size.height * 0.5) {
      bloc.changeToCart();
    } else {
      bloc.changeToDetails();
    }
  }

  void movimientoTerminado(DragEndDetails details) {
    if (_currentHeight >= MediaQuery.of(context).size.height * 0.5) {
      setState(() {
        _currentHeight = targetExpandedHeight;
      });
      bloc.changeToCart();
    } else {
      setState(() {
        _currentHeight = targetCollapsedHeight;
      });
      bloc.changeToNormal();
    }
  }

  Future<Sucursal?> obtenerSucursal() async {
    PreferenciasUsuario prefs = PreferenciasUsuario();
    final firestoreInstance = FirebaseFirestore.instance;
    final sucursalRepository = SucursalRepositoryImpl(firestoreInstance);

    return await sucursalRepository.buscarSucursalPorId(prefs.sucursalId!);
  }

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;

    return FutureBuilder<Sucursal?>(
      future: ubicacionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final Sucursal? ubicacion = snapshot.data;
          if (ubicacion == null) {
            return const Center(child: Text('No se encontró la sucursal'));
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProductosBloc(
                    CategoriaProductosRepositoryImpl(
                        firestore: firestoreInstance)),
              ),
            ],
            child: ChangeNotifierProvider(
              create: (context) => PresentacionPedidosBloc(),
              child: Scaffold(
                drawer: const MyDrawer(),
                body: GestureDetector(
                  onVerticalDragUpdate: movimientoVerticalCarrito,
                  onVerticalDragEnd: movimientoTerminado,
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
                            child: VistaProductosIndividual(
                              bloc: _sliverScrollController,
                              sucursal: ubicacion,
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
                            color: Theme.of(context).colorScheme.tertiary,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Consumer<PresentacionPedidosBloc>(
                                  key: ValueKey(bloc.presentacionState),
                                  builder: (context, bloc, _) {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: _currentHeight >=
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25
                                          ? const VistaCarritoEmpleado()
                                          : Row(
                                              children: [
                                                const Text(
                                                  'Carrito',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: bloc.presentacionState ==
                                                          PresentacionPedidoState
                                                              .cart
                                                      ? const SizedBox.shrink()
                                                      : SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children:
                                                                List.generate(
                                                                    bloc.carrito
                                                                        .length,
                                                                    (index) =>
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 5.0),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Hero(
                                                                                tag: 'list_${bloc.carrito[index].producto.id}_details_$index', // Make tag unique
                                                                                child: CircleAvatar(
                                                                                  backgroundImage: bloc.carrito[index].producto.imagenPrincipal != null ? NetworkImage(bloc.carrito[index].producto.imagenPrincipal!) : const AssetImage('assets/restaurant.png'),
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                right: 0,
                                                                                child: CircleAvatar(
                                                                                  radius: 10,
                                                                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                                                                  child: Text(
                                                                                    '${bloc.carrito[index].cantidad}',
                                                                                    style: const TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                          ),
                                                        ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'S/. ${bloc.carrito.fold<double>(0.0, (total, item) => total + item.producto.precio * item.cantidad).toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    );
                                  },
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
            ),
          );
        } else {
          return const Center(child: Text('No se encontró la sucursal'));
        }
      },
    );
  }
}

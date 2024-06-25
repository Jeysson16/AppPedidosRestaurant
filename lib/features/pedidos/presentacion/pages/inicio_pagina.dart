import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/global/view/components/my_sliver_app_bar.dart';
import 'package:restaurant_app/features/mesa/data/repositorios/firebase_sucursal_repositorio.dart';
import 'package:restaurant_app/features/mesa/presentacion/bloc/sucursal_bloc.dart';
import 'package:restaurant_app/app/global/view/components/my_drawer.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_banner_repositorio.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_bloc.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_event.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_state.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/home_sliver.dart';

class InicioPagina extends StatefulWidget {
  const InicioPagina({super.key});

  @override
  State<InicioPagina> createState() => _InicioPaginaState();
}

class _InicioPaginaState extends State<InicioPagina> {
  String? sucursalSeleccionada;

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    final sucursalRepository = SucursalRepositoryImpl(firestoreInstance);
    final categoriaProductosRepository = CategoriaProductosRepositoryImpl(firestore: firestoreInstance);
    final bannerRepository = BannerRepositorioImpl(firestore: firestoreInstance);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SucursalBloc(sucursalRepository)..add(LoadSucursales()),
        ),
        BlocProvider(
          create: (context) => ProductosBloc(categoriaProductosRepository),
        ),
      ],
      child: Scaffold(
        drawer: const MyDrawer(),
        body: BlocBuilder<SucursalBloc, SucursalState>(
          builder: (context, sucursalState) {
            if (sucursalState is SucursalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (sucursalState is SucursalLoaded) {
              final sucursales = sucursalState.sucursales;

              if (sucursales.isNotEmpty && sucursalSeleccionada == null) {
                sucursalSeleccionada = "fXRPjNfB9ZehJPBR640y";
              }

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  MySliverAppBar(
                    title: const Text("Menú del Dia"),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: sucursalSeleccionada,
                          hint: const Text("Seleccionar sucursal"),
                          items: sucursales.map((sucursal) {
                            return DropdownMenuItem<String>(
                              value: sucursal.id,
                              child: Text(sucursal.nombreSucursal),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              sucursalSeleccionada = newValue;
                              if (newValue != null) {
                                context.read<ProductosBloc>().add(LoadProductos(newValue));
                              }
                            });
                          },
                        ),
                        if (sucursalSeleccionada != null && sucursales.any((sucursal) => sucursal.id == sucursalSeleccionada))
                          BlocBuilder<ProductosBloc, ProductosState>(
                            builder: (context, productosState) {
                              if (productosState is ProductosLoading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (productosState is ProductosLoaded) {
                                final categoriasConProductos = productosState.categoriasConProductos;
                                final sucursalSeleccionadaData = sucursales.firstWhere((sucursal) => sucursal.id == sucursalSeleccionada);

                                return HomeSliverWithTab(
                                  bloc: SliverScrollController(
                                    categoriaProductosRepository,
                                    bannerRepository,
                                  ),
                                );
                              } else if (productosState is ProductosError) {
                                return Center(child: Text(productosState.message));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
                body: Container(
                  color: Theme.of(context).colorScheme.error,
                  height: 400,
                  // Aquí incluimos el HomeSliverWithTab en lugar de MiUbicacion
                  child: HomeSliverWithTab(
                    bloc: SliverScrollController(
                      categoriaProductosRepository,
                      bannerRepository,
                    ),
                    ),
                ),
              );
            } else if (sucursalState is SucursalError) {
              return Center(child: Text(sucursalState.message));
            }

            return const Center(child: Text('No hay sucursales disponibles'));
          },
        ),
      ),
    );
  }
}
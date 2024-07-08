import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/view/components/cargando_pagina.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/background_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/list_item_header_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/my_heather_title.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_body_items.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_header_data.dart';

class VistaProductosIndividual extends StatefulWidget {
  final SliverScrollController bloc;
  final Sucursal sucursal;

  const VistaProductosIndividual({
    super.key,
    required this.bloc,
    required this.sucursal,
  });

  @override
  State<VistaProductosIndividual> createState() =>
      _VistaProductosIndividualState();
}

class _VistaProductosIndividualState extends State<VistaProductosIndividual> {
  @override
  void initState() {
    super.initState();
    widget.bloc.loadData(widget.sucursal).then((_) {
      setState(() {
        print(
            "Data: ${widget.bloc.listCategory}, Sucursal: ${widget.sucursal.nombreSucursal}");
      });
    });
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  void handleBannerTap(String? categoryId, String? productId) {
    if (categoryId != null) {
      scrollToCategory(categoryId);
    }
  }

  void scrollToCategory(String categoryId) {
    widget.bloc.scrollToCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.loadData(widget.sucursal);
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: widget.bloc.listCategory.isEmpty
                        ? const CustomLoadingPage()
                        : NotificationListener<ScrollNotification>(
                            onNotification: (scroll) {
                              if (scroll is ScrollUpdateNotification) {
                                widget.bloc.valueScroll.value =
                                    scroll.metrics.extentInside;
                              }
                              return true;
                            },
                            child: Scrollbar(
                              radius: const Radius.circular(8),
                              child: ValueListenableBuilder<double>(
                                valueListenable: widget.bloc.globalOffsetValue,
                                builder: (_, double valueCurrentScroll, __) {
                                  return CustomScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller:
                                        widget.bloc.scrollControllerGlobally,
                                    slivers: [
                                      _FlexibleSpaceBarHeader(
                                        valueScroll: valueCurrentScroll,
                                        bloc: widget.bloc,
                                        sucursal: widget.sucursal,
                                      ),
                                      SliverPersistentHeader(
                                        pinned: true,
                                        delegate: _HeaderSliver(
                                          bloc: widget.bloc,
                                          sucursal: widget.sucursal,
                                        ),
                                      ),
                                      for (var category
                                          in widget.bloc.listCategory) ...[
                                        SliverPersistentHeader(
                                          delegate: MyHeaderTitle(
                                            category.nombre,
                                            (visible) =>
                                                widget.bloc.refreshHeader(
                                              widget.bloc.listCategory
                                                  .indexOf(category),
                                              visible,
                                              lastIndex: widget
                                                          .bloc.listCategory
                                                          .indexOf(category) >
                                                      0
                                                  ? widget.bloc.listCategory
                                                          .indexOf(category) -
                                                      1
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SliverBodyItems(
                                          listItem: category.productos,
                                          key: widget
                                              .bloc.categoryKeys[category.id],
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader({
    required this.valueScroll,
    required this.bloc,
    required this.sucursal,
  });

  final double valueScroll;
  final SliverScrollController bloc;
  final Sucursal sucursal;

  void handleBannerTap(String? categoryId, String? productId) {
    if (categoryId != null) {
      bloc.scrollToCategory(categoryId);
    }
    // Add logic here if you need to scroll to a specific product within a category
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      stretch: true,
      expandedHeight: 200,
      pinned: valueScroll < 70,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundSliver(
              banners: bloc.banners,
              onBannerTap: handleBannerTap,
            ),
          ],
        ),
      ),
    );
  }
}

const _maxHeaderExtent = 110.0;

class _HeaderSliver extends SliverPersistentHeaderDelegate {
  _HeaderSliver({required this.bloc, required this.sucursal});

  final SliverScrollController bloc;
  final Sucursal sucursal;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
      bloc.visibleHeader.value = true;
    } else {
      bloc.visibleHeader.value = false;
    }
    return Container(
      height: _maxHeaderExtent,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (percent > 0.1) // Mostrar la flecha solo si percent > 0.1
                  GestureDetector(
                    onTap: () {
                      // Acción para hacer scroll al inicio
                      bloc.scrollToTop();
                    },
                    child: AnimatedOpacity(
                      opacity: percent > 0.1 ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                if (percent > 0.1)
                  const SizedBox(
                      width:
                          8.0), // Añadimos espacio solo si la flecha está visible
                Expanded(
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    offset: Offset(percent < 0.1 ? 0 : 0.01,
                        0), // Ajustamos el desplazamiento para que sea más sutil
                    curve: Curves.easeIn,
                    child: Text(
                      sucursal.nombreSucursal,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: percent > 0.1
                  ? ListItemHeaderSliver(bloc: bloc)
                  : SliverHeaderData(
                      cuisine: sucursal.direccion,
                      horaAtencion:
                          '${sucursal.horaAtencionAbierto} - ${sucursal.horaAtencionCerrado}',
                      estado: sucursal.estado,
                      telefono: sucursal.telefono,
                    ),
            ),
          ),
          if (percent > 0.1)
            Container(
              height: 0.5,
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true; // Cambiado a true para forzar la reconstrucción
}

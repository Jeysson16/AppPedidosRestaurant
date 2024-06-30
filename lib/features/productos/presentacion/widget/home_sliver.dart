import 'package:flutter/material.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/productos/presentacion/controller/sliver_controll_controller.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/background_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/list_item_header_sliver.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/my_heather_title.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_body_items.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/sliver_header_data.dart';

class HomeSliverWithTab extends StatefulWidget {
  final SliverScrollController bloc;
  final List<Sucursal> sucursales;

  const HomeSliverWithTab({
    super.key,
    required this.bloc,
    required this.sucursales,
  });

  @override
  State<HomeSliverWithTab> createState() => _HomeSliverWithTabState();
}

class _HomeSliverWithTabState extends State<HomeSliverWithTab> {
  String? sucursalSeleccionada;
  Sucursal? sucursalSeleccionadaData;
final ValueNotifier<bool> showDropdown = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    if (widget.sucursales.isNotEmpty) {
      sucursalSeleccionada = widget.sucursales.first.id;
      sucursalSeleccionadaData = widget.sucursales.first;
      widget.bloc.loadData(sucursalSeleccionadaData!).then((_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context), // Usa el tema actual
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), 
              child: ValueListenableBuilder<bool>(
                valueListenable: showDropdown,
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: value
                        ? Container(
                        key: ValueKey(sucursalSeleccionada),
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary,width: 1),
                  borderRadius: BorderRadius.circular(15)
                ),
                
              child: DropdownButton<String>(
                value: sucursalSeleccionada,
                isExpanded: true,
                hint: const Text("Seleccionar sucursal"),
                items: widget.sucursales.map((sucursal) {
                  return DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: sucursal.id,
                    child: Text(
                        sucursal.nombreSucursal,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sucursalSeleccionada = newValue;
                    if (newValue != null) {
                      sucursalSeleccionadaData = widget.sucursales.firstWhere((sucursal) => sucursal.id == newValue);
                      widget.bloc.loadData(sucursalSeleccionadaData!).then((_) {
                        setState(() {}); // Forzar actualización de la UI
                      });
                    }
                  });
                },
                  dropdownColor: Theme.of(context).colorScheme.surface, // Color de fondo del menú desplegable
                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).iconTheme.color), // Color del icono
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, // Color del texto seleccionado
                    fontSize: 16,
                    ),
                      ),
                    )
                  : const SizedBox.shrink(),
                  );
                },
              ),
            ),
            Expanded(
              child: widget.bloc.listCategory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll is ScrollUpdateNotification) {
                          widget.bloc.valueScroll.value = scroll.metrics.extentInside;
                        if (scroll.metrics.pixels > 0 && showDropdown.value) {
                            showDropdown.value = false;
                          } else if (scroll.metrics.pixels <= 0 && !showDropdown.value) {
                            showDropdown.value = true;
                          }
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
                              controller: widget.bloc.scrollControllerGlobally,
                              slivers: [
                                _FlexibleSpaceBarHeader(
                                  valueScroll: valueCurrentScroll,
                                  bloc: widget.bloc,
                                  sucursal: sucursalSeleccionadaData!,
                                ),
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _HeaderSliver(
                                    bloc: widget.bloc,
                                    sucursal: sucursalSeleccionadaData!,
                                  ),
                                ),
                                for (var i = 0; i < widget.bloc.listCategory.length; i++) ...[
                                  SliverPersistentHeader(
                                    delegate: MyHeaderTitle(
                                      widget.bloc.listCategory[i].nombre,
                                      (visible) => widget.bloc.refreshHeader(
                                        i,
                                        visible,
                                        lastIndex: i > 0 ? i - 1 : null,
                                      ),
                                    ),
                                  ),
                                  SliverBodyItems(listItem: widget.bloc.listCategory[i].productos),
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

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      stretch: true,
      expandedHeight: 250,
      pinned: valueScroll < 90,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (bloc.bannerUrls.isNotEmpty)
              BackgroundSliver(bannerUrls: bloc.bannerUrls),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
          const SizedBox(width: 20),
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
                if (percent > 0.1) const SizedBox(width: 8.0), // Añadimos espacio solo si la flecha está visible
                Expanded(
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    offset: Offset(percent < 0.1 ? 0 : 0.01, 0), // Ajustamos el desplazamiento para que sea más sutil
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
              duration: const Duration(milliseconds: 400),
              child: percent > 0.1
                  ? ListItemHeaderSliver(bloc: bloc)
                  : SliverHeaderData(
                      cuisine: sucursal.direccion,
                      horaAtencion: '${sucursal.horaAtencionAbierto} - ${sucursal.horaAtencionCerrado}',
                      estado: sucursal.estado,
                      telefono: sucursal.telefono,
                    ),
            ),
          ),
          if (percent > 0.1)
            Container(
              height: 0.5,
              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true; // Cambiado a true para forzar la reconstrucción
}
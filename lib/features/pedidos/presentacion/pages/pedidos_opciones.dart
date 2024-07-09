import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_direccion.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/pedido_mesa_pagina.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/pedido_reserva_pagina.dart';
import 'package:restaurant_app/features/pedidos/presentacion/widget/producto_carrusel.dart';

enum SliderAction {
  next,
  previous,
  none,
}

class OptionButton {
  final String imagePath;
  final String label;
  final String description;

  OptionButton({
    required this.imagePath,
    required this.label,
    required this.description,
  });
}

class PedidoOptionsScreen extends StatefulWidget {
  final PresentacionPedidosBloc bloc;

  const PedidoOptionsScreen(
      {super.key, required this.bloc, required this.initialAction});

  final SliderAction initialAction;
  @override
  _PedidoOptionsScreenState createState() => _PedidoOptionsScreenState();
}

class _PedidoOptionsScreenState extends State<PedidoOptionsScreen> {
  late PresentacionPedidosBloc bloc;
  late PageController _sliderPageController;
  late PageController _titlePageController;
  late int _index;
  late double _percent;
  late ScrollController _scrollControllerVertical;
  double _expandedHeight = 0.1;

  List<OptionButton> options = [
    OptionButton(
      imagePath: 'assets/pide_qr.png',
      label: 'Pídelo en tu mesa',
      description:
          '¿Prefieres disfrutar de la comida en el restaurante? Haz tu pedido desde tu mesa y espera cómodamente.',
    ),
    OptionButton(
      imagePath: 'assets/pide_delivery.png',
      label: 'Pídelo por delivery',
      description:
          '¿Quieres disfrutar nuestra comida en casa? Pide delivery y te lo llevamos rápidamente a tu puerta.',
    ),
    OptionButton(
      imagePath: 'assets/pide_reserva.png',
      label: 'Pedir una reserva',
      description:
          '¿Planeas visitarnos pronto? Haz una reserva y asegura tu lugar para una experiencia gastronómica sin contratiempos.',
    ),
  ];
  void _pageListener() {
    _index = _sliderPageController.page!.floor();
    _percent = (_sliderPageController.page! - _index).abs();
    setState(() {});
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _expandedHeight +=
          details.primaryDelta! / MediaQuery.of(context).size.height;
      _expandedHeight = _expandedHeight.clamp(0.2, 0.5);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      if (_expandedHeight > 0.35) {
        _expandedHeight = 0.5;
      } else {
        _expandedHeight = 0.2;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _index = 2;
    _sliderPageController = PageController(initialPage: _index);
    _titlePageController = PageController(initialPage: _index);
    _percent = 0.0;
    _sliderPageController.addListener(_pageListener);
    _scrollControllerVertical = ScrollController();

    Future.delayed(const Duration(milliseconds: 400), () {
      _initialAction(widget.initialAction);
    });

    bloc = widget.bloc;
  }

  @override
  void dispose() {
    _sliderPageController.removeListener(_pageListener);
    _sliderPageController.dispose();
    _titlePageController.dispose();
    _scrollControllerVertical.dispose();

    super.dispose();
  }

  void _initialAction(SliderAction sliderAction) {
    switch (sliderAction) {
      case SliderAction.none:
        break;
      case SliderAction.next:
        _sliderPageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn);
        break;
      case SliderAction.previous:
        _sliderPageController.previousPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Escoge una opción',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height:
                  MediaQuery.of(context).size.height * _expandedHeight * 1.2,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(options[index].imagePath),
                    ),
                    title: Text(
                      options[index].label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(options[index].description),
                    onTap: () {
                      if (options[index].label == 'Pídelo en tu mesa') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PedidoMesaPagina()),
                        );
                      } else if (options[index].label ==
                          'Pídelo por delivery') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MiUbicacion(
                              bloc: bloc,
                            ),
                          ),
                        );
                      } else if (options[index].label == 'Pedir una reserva') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PedidoReservaPagina()),
                        );
                      } else {}
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            child: PageView.builder(
              itemCount: bloc.carrito.length,
              physics: const NeverScrollableScrollPhysics(),
              controller: _titlePageController,
              itemBuilder: (context, index) {
                return _TituloProducto(
                  item: bloc.carrito[index],
                  total: bloc.carrito[index].calcularPrecioTotal(),
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.75, 1.0],
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                    ),
                  ),
                ),
                ItemsCarrusel(
                  percent: _percent,
                  itemsCarrito: bloc.carrito,
                  index: _index,
                ),
                PageView.builder(
                  controller: _sliderPageController,
                  onPageChanged: (value) {
                    _titlePageController.animateToPage(value,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn);
                  },
                  itemCount: bloc.carrito.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {},
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TituloProducto extends StatelessWidget {
  const _TituloProducto({
    required this.item,
    required this.total,
  });

  final PedidoSeleccionadoItem item;
  final double total;

  @override
  Widget build(BuildContext context) {
    String heroTag = 'producto-${item.producto.nombre}';
    if (item.selectedVarianteIndex != null &&
        item.selectedVarianteIndex! >= 0 &&
        item.selectedVarianteIndex! < item.producto.variantes!.length) {
      heroTag +=
          '-variante-${item.producto.variantes![item.selectedVarianteIndex!].nombre}';
    }
    if (item.selectedTamanoIndex != null &&
        item.selectedTamanoIndex! >= 0 &&
        item.selectedTamanoIndex! < item.producto.tamanos!.length) {
      heroTag +=
          '-tamano-${item.producto.tamanos![item.selectedTamanoIndex!].nombre}';
    }
    if (item.selectedAgregados != null &&
        item.selectedAgregados!.isNotEmpty &&
        item.selectedAgregados!.every(
            (index) => index >= 0 && index < item.producto.agregados!.length)) {
      heroTag +=
          '-agregados-${item.selectedAgregados!.map((index) => item.producto.agregados![index].nombre).join(', ')}';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .85,
          child: Hero(
            tag: '${heroTag}detalle',
            child: Row(
              children: [
                Text(
                  item.producto.nombre,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow
                      .ellipsis, // Maneja el desbordamiento con puntos suspensivos
                ),
                const Spacer(),
                Text(
                  "S/. ${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Cantidad: ${item.cantidad}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        if (item.selectedTamanoIndex != null &&
            item.selectedTamanoIndex! >= 0 &&
            item.selectedTamanoIndex! < item.producto.tamanos!.length)
          Text(
            item.producto.tamanos![item.selectedTamanoIndex!].nombre,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 16,
            ),
          ),
        if (item.selectedVarianteIndex != null &&
            item.selectedVarianteIndex! >= 0 &&
            item.selectedVarianteIndex! < item.producto.variantes!.length)
          Text(
            item.producto.variantes![item.selectedVarianteIndex!].nombre,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 16,
            ),
          ),
        if (item.selectedAgregados != null &&
            item.selectedAgregados!.isNotEmpty &&
            item.selectedAgregados!.every((index) =>
                index >= 0 && index < item.producto.agregados!.length))
          Text(
            "Agregados: ${item.selectedAgregados!.map((index) => item.producto.agregados![index].nombre).join(', ')}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Observaciones:",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            " ${item.observaciones.join(', ')}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

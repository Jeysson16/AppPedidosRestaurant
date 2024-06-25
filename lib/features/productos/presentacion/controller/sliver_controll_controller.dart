import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restaurant_app/features/productos/data/models/my_header.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/banner_repositorio.dart';

class SliverScrollController {
  // Repositorio de categorías con productos
  final CategoriaProductosRepositoryImpl categoriaProductosRepository;
  final BannerRepository bannerRepository;

  SliverScrollController(this.categoriaProductosRepository, this.bannerRepository) {
    scrollControllerGlobally = ScrollController();
    listCategory = [];
    bannerUrls = [];
  }

  // Lista de URLs de banners
  late List<String> bannerUrls;

  // Lista de categorías con productos
  late List<CategoriaProductos> listCategory;

  // Lista de valores offSet de los item
  List<double> listOffSetItemHeader = [];

  // Notificaciones de cabecera
  final headerNotifier = ValueNotifier<MyHeader?>(null);

  // Valor actual de scroll
  final globalOffsetValue = ValueNotifier<double>(0);

  // Indicador si estamos bajando o subiendo en la aplicación
  final goingDown = ValueNotifier<bool>(false);

  // Valor para hacer las validaciones de los iconos superiores
  final valueScroll = ValueNotifier<double>(0);

  // Para mover los items superiores en sliver
  late ScrollController scrollControllerItemHeader;

  // Para tener control total del scroll
  late ScrollController scrollControllerGlobally;

  // Valor que indica si el encabezado es visible
  final visibleHeader = ValueNotifier(false);

  Future<void> loadData(String sucursalId) async {
    listCategory = await categoriaProductosRepository.obtenerCategoriasConProductos(sucursalId);
    var banners = await bannerRepository.obtenerBanners(sucursalId);
    bannerUrls = banners.map((banner) => banner.url!).toList();

    listOffSetItemHeader = List.generate(listCategory.length, (index) => index.toDouble());

    scrollControllerItemHeader = ScrollController();

    headerNotifier.addListener(_listenHeaderNotifier);
    scrollControllerGlobally.addListener(_listenToScrollChange);
    visibleHeader.addListener(_listenVisibleHeader);
  }

  void _listenVisibleHeader() {
    if (visibleHeader.value) {
      headerNotifier.value = const MyHeader(visible: false, index: 0);
    }
  }

  void dispose() {
    scrollControllerItemHeader.dispose();
    scrollControllerGlobally.dispose();
  }

  void _listenHeaderNotifier() {
    if (visibleHeader.value) {
      for (var i = 0; i < listCategory.length; i++) {
        scrollAnimationHorizontal(index: i);
      }
    }
  }

  void _listenToScrollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
    if (scrollControllerGlobally.position.userScrollDirection == ScrollDirection.reverse) {
      goingDown.value = true;
    } else {
      goingDown.value = false;
    }
  }

  void scrollAnimationHorizontal({required int index}) {
    if (headerNotifier.value?.index == index && headerNotifier.value!.visible) {
      scrollControllerItemHeader.animateTo(
        listOffSetItemHeader[headerNotifier.value!.index] - 16,
        duration: const Duration(milliseconds: 500),
        curve: goingDown.value ? Curves.bounceOut : Curves.fastOutSlowIn,
      );
    }
  }

  void refreshHeader(int index, bool visible, {int? lastIndex}) {
    final headerValue = headerNotifier.value;
    final headerTitle = headerValue?.index ?? index;
    final headerVisible = headerValue?.visible ?? false;

    if (headerTitle != index || lastIndex != null || headerVisible != visible) {
      Future.microtask(() {
        if (!visible && lastIndex != null) {
          headerNotifier.value = MyHeader(visible: true, index: lastIndex);
        } else {
          headerNotifier.value = MyHeader(visible: visible, index: index);
        }
      });
    }
  }
}
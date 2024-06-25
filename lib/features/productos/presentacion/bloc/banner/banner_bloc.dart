import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/productos/dominio/casos_uso/banner/obtener_banners.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/banner/banner_event.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/banner/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final ObtenerBanners obtenerBanners;

  BannerBloc(this.obtenerBanners) : super(BannerInitial());

  Stream<BannerState> mapEventToState(BannerEvent event) async* {
    if (event is ObtenerBannersEvent) {
      yield BannerLoading();
      try {
        final banners = await obtenerBanners(event.sucursalId);
        yield BannerLoaded(banners: banners);
      } catch (e) {
        yield BannerError(e.toString(), message: 'Error al obtener los banners');
      }
    }
  }
}
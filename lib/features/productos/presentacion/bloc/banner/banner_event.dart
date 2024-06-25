import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object> get props => [];
}

class ObtenerBannersEvent extends BannerEvent {
  final String sucursalId;

  const ObtenerBannersEvent(this.sucursalId);

  @override
  List<Object> get props => [sucursalId];
}
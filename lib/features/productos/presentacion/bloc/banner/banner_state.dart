import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/banner.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerOfertas> banners;

  const BannerLoaded({required this.banners});

  @override
  List<Object> get props => [banners];
}

class BannerError extends BannerState {
  final String message;

  const BannerError(String string, {required this.message});

  @override
  List<Object> get props => [message];
}
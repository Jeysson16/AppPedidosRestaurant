import 'package:equatable/equatable.dart';

abstract class BienvenidaEvent extends Equatable {
  const BienvenidaEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthEvent extends BienvenidaEvent {}

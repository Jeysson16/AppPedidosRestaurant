import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class IniciarSesionEvent extends AuthEvent {
  final String email;
  final String password;

  IniciarSesionEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

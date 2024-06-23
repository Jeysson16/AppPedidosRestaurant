import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInAnonymouslyEvent extends AuthEvent {}

class RegistrarEmpleadoEvent extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> employeeData;

  const RegistrarEmpleadoEvent(this.email, this.password, this.employeeData);

  @override
  List<Object> get props => [email, password, employeeData];
}

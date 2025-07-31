import 'package:equatable/equatable.dart';

abstract class BaseEmailChanged extends Equatable {
  final String email;
  const BaseEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

abstract class BasePasswordChanged extends Equatable {
  final String password;
  const BasePasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

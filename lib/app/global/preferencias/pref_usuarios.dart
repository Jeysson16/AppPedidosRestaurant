import 'dart:convert';
import 'package:restaurant_app/features/auth/dominio/entidades/empleado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Empleado? get empleado {
    String? empleadoJson = _prefs.getString('empleado');
    return Empleado.fromJson(jsonDecode(empleadoJson!));
  }

  set empleado(Empleado? value) {
    if (value != null) {
      _prefs.setString('empleado', jsonEncode(value.toJson()));
    } else {
      _prefs.remove('empleado');
    }
  }

  List<String>? get permisos {
    return _prefs.getStringList('permisos');
  }

  set permisos(List<String>? value) {
    if (value != null) {
      _prefs.setStringList('permisos', value);
    } else {
      _prefs.remove('permisos');
    }
  }

  String? get usuarioDni {
    return _prefs.getString('usuarioDni');
  }

  set usuarioDni(String? value) {
    if (value != null) {
      _prefs.setString('usuarioDni', value);
    }
  }

  String? get pisoId {
    return _prefs.getString('pisoId');
  }

  set pisoId(String? value) {
    if (value != null) {
      _prefs.setString('pisoId', value);
    }
  }

  String? get sucursalId {
    return _prefs.getString('sucursalId');
  }

  set sucursalId(String? value) {
    if (value != null) {
      _prefs.setString('sucursalId', value);
    }
  }

  String? get mesaId {
    return _prefs.getString('mesaId');
  }

  set mesaId(String? value) {
    if (value != null) {
      _prefs.setString('mesaId', value);
    }
  }

  String? get ultimaPagina {
    return _prefs.getString('ultimaPagina');
  }

  set ultimaPagina(String? value) {
    if (value != null) {
      _prefs.setString('ultimaPagina', value);
    }
  }
}

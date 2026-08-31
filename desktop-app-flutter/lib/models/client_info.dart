/// Datos de cliente + requerimientos — concepto de UI local a esta sesión.
/// No existe tabla en el backend todavía: nunca se serializa ni se envía a
/// la API, para no romper el contrato que ya consume el portafolio.
class Requirement {
  String text;
  bool done;
  Requirement({required this.text, this.done = false});
}

class ClientInfo {
  String name;
  String company;
  String email;
  String phone;
  List<Requirement> requirements;

  ClientInfo({
    this.name = '',
    this.company = '',
    this.email = '',
    this.phone = '',
    List<Requirement>? requirements,
  }) : requirements = requirements ?? [];
}

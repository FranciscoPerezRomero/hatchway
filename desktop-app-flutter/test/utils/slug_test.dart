import 'package:flutter_test/flutter_test.dart';
import 'package:hatchway_desktop/utils/slug.dart';

void main() {
  test('convierte a minúsculas y reemplaza espacios por guiones', () {
    expect(generateSlug('Mi Proyecto Genial'), 'mi-proyecto-genial');
  });

  test('elimina acentos', () {
    expect(generateSlug('Administración de sesión'), 'administracion-de-sesion');
  });

  test('elimina caracteres no permitidos', () {
    expect(generateSlug('Hola! ¿Qué tal? #1'), 'hola-que-tal-1');
  });

  test('colapsa espacios múltiples', () {
    expect(generateSlug('uno   dos    tres'), 'uno-dos-tres');
  });
}

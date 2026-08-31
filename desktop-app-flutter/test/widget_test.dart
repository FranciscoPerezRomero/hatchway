// Smoke test deliberadamente mínimo: HatchwayApp dispara fetchProjects()
// (llamada de red real) desde initState, así que no se hace pump completo
// aquí para no depender de conectividad en CI. Los tests funcionales viven
// en slug_test.dart y project_test.dart.
import 'package:flutter_test/flutter_test.dart';
import 'package:hatchway_desktop/main.dart';

void main() {
  test('HatchwayApp se puede instanciar', () {
    expect(() => const HatchwayApp(), returnsNormally);
  });
}

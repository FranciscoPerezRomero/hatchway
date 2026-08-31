/// Port de generateSlug() en ProjectForm.tsx: minúsculas, sin acentos,
/// solo [a-z0-9\s-], espacios colapsados a guiones.
String generateSlug(String title) {
  final lower = title.toLowerCase();
  final normalized = _stripDiacritics(lower);
  final cleaned = normalized.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
  final trimmed = cleaned.trim();
  return trimmed.replaceAll(RegExp(r'\s+'), '-');
}

const _accented = 'áàäâãåéèëêíìïîóòöôõúùüûñç';
const _plain = 'aaaaaaeeeeiiiiooooouuuunc';

String _stripDiacritics(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final idx = _accented.indexOf(ch);
    buffer.write(idx == -1 ? ch : _plain[idx]);
  }
  return buffer.toString();
}

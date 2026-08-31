/// Límite alineado con el client_max_body_size (20m) configurado en nginx
/// para api.plicdreft.com. Rechazar localmente evita mostrarle al usuario
/// un 413 crudo del servidor.
const int kMaxUploadBytes = 20 * 1024 * 1024;

bool exceedsUploadLimit(int sizeBytes) => sizeBytes > kMaxUploadBytes;

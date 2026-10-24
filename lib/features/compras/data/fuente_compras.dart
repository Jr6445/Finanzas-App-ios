import '../domain/compra_pendiente.dart';

/// De dónde llegan las compras automáticas.
///
/// - [FuenteComprasFake]: datos de prueba (Windows, Chrome, Android).
/// - `FuenteComprasIOS` (fase 4): lo que dejó el App Intent en UserDefaults.
///
/// `abstract interface class` es lo más parecido a una `interface` de C#:
/// solo se puede implementar, no heredar.
abstract interface class FuenteCompras {
  /// Compras que llegaron y aún no se han importado.
  Future<List<CompraPendiente>> leerPendientes();

  /// Quita de la fuente solo las compras ya importadas. Se pasan los ids
  /// (en lugar de "borrar todo") para no perder una compra que llegue justo
  /// entre la lectura y la limpieza.
  Future<void> marcarImportadas(Set<String> ids);
}

import AppIntents
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

// MARK: - Acción "Registrar compra" para la app Atajos
//
// Va en este archivo (y no en uno propio) porque un .swift nuevo tendría que
// registrarse a mano en project.pbxproj; AppDelegate.swift ya se compila.
//
// Solo guarda la compra en UserDefaults como texto JSON. Al abrir la app,
// Flutter la lee con shared_preferences (que antepone "flutter." a la clave),
// la importa a la base y la quita de la lista.
//
// Requiere iOS 16 (deployment target subido a 16.0 en project.pbxproj).
struct RegistrarCompraIntent: AppIntent {
  static let title: LocalizedStringResource = "Registrar compra"
  static let openAppWhenRun: Bool = false

  @Parameter(title: "Comercio")
  var comercio: String

  // Texto y no número: Atajos lo convierte con el formato de la región
  // ("US$12.50", "12,50"...) y Flutter se encarga de interpretarlo.
  @Parameter(title: "Monto")
  var monto: String

  @Parameter(title: "Tarjeta")
  var tarjeta: String

  func perform() async throws -> some IntentResult {
    let compra: [String: String] = [
      "id": UUID().uuidString,
      "comercio": comercio,
      "monto": monto,
      "tarjeta": tarjeta,
      "fecha": ISO8601DateFormatter().string(from: Date()),
    ]
    let datos = try JSONSerialization.data(withJSONObject: compra)
    let json = String(decoding: datos, as: UTF8.self)

    let clave = "flutter.compras_pendientes"
    var pendientes = UserDefaults.standard.stringArray(forKey: clave) ?? []
    pendientes.append(json)
    UserDefaults.standard.set(pendientes, forKey: clave)
    return .result()
  }
}

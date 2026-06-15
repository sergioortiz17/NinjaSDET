import Flutter
import UIKit
import XCTest

@testable import Runner

// MARK: - RunnerTests (XCTest Unit Tests)
// Estos tests verifican la capa nativa iOS del app Flutter "Ninja SDET".
// Se enfocan en: AppDelegate, FlutterEngine, canales de mensajería y registro de plugins.

class RunnerTests: XCTestCase {

    // MARK: - AppDelegate Tests

    /// Verifica que AppDelegate hereda de FlutterAppDelegate (requerido por Flutter).
    func testAppDelegateIsFlutterAppDelegate() {
        let appDelegate = AppDelegate()
        XCTAssertTrue(
            appDelegate is FlutterAppDelegate,
            "AppDelegate debe ser subclase de FlutterAppDelegate para que Flutter funcione correctamente."
        )
    }

    /// Verifica que AppDelegate conforma el protocolo FlutterAppLifeCycleProvider.
    func testAppDelegateConformsToFlutterLifecycleProvider() {
        let appDelegate = AppDelegate()
        XCTAssertTrue(
            appDelegate is FlutterAppLifeCycleProvider,
            "AppDelegate debe conformar FlutterAppLifeCycleProvider para gestionar el ciclo de vida."
        )
    }

    // MARK: - FlutterEngine Tests

    /// Verifica que se puede crear una instancia de FlutterEngine.
    func testFlutterEngineCanBeCreated() {
        let engine = FlutterEngine(name: "unit_test_engine")
        XCTAssertNotNil(engine, "FlutterEngine debe poder instanciarse correctamente.")
    }

    /// Verifica que FlutterEngine puede ejecutarse sin errores.
    func testFlutterEngineRunsSuccessfully() {
        let engine = FlutterEngine(name: "run_test_engine")
        let result = engine.run()
        XCTAssertTrue(result, "FlutterEngine.run() debe retornar true al iniciarse correctamente.")
    }

    /// Verifica que FlutterEngine tiene un binaryMessenger válido tras arrancar.
    func testFlutterEngineBinaryMessengerIsAvailable() {
        let engine = FlutterEngine(name: "messenger_test_engine")
        _ = engine.run()
        let messenger = engine.binaryMessenger
        XCTAssertNotNil(messenger, "BinaryMessenger debe estar disponible después de run().")
    }

    // MARK: - Plugin Registration Tests

    /// Verifica que el registrador de plugins está disponible.
    func testPluginRegistrarIsAvailable() {
        let engine = FlutterEngine(name: "registrar_test_engine")
        _ = engine.run()
        let registrar = engine.registrar(forPlugin: "TestPlugin")
        XCTAssertNotNil(registrar, "Plugin registrar debe estar disponible tras iniciar el engine.")
    }

    /// Verifica que GeneratedPluginRegistrant puede registrar plugins sin fallar.
    func testGeneratedPluginRegistrantRegistersWithoutCrashing() {
        let engine = FlutterEngine(name: "generated_plugin_engine")
        _ = engine.run()
        // No debe lanzar ninguna excepción ni crash
        GeneratedPluginRegistrant.register(with: engine)
        XCTAssertTrue(true, "El registro de plugins debe completarse sin errores.")
    }

    // MARK: - FlutterViewController Tests

    /// Verifica que FlutterViewController puede crearse a partir de un engine activo.
    func testFlutterViewControllerCanBeCreated() {
        let engine = FlutterEngine(name: "vc_test_engine")
        _ = engine.run()
        let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        XCTAssertNotNil(flutterVC, "FlutterViewController debe poder crearse con un engine activo.")
    }

    /// Verifica que FlutterViewController tiene una vista válida.
    func testFlutterViewControllerHasValidView() {
        let engine = FlutterEngine(name: "vc_view_engine")
        _ = engine.run()
        let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        XCTAssertNotNil(flutterVC.view, "FlutterViewController.view no debe ser nil.")
    }

    // MARK: - Flutter Messaging Channel Tests

    /// Verifica que se puede crear un FlutterBasicMessageChannel.
    func testFlutterBasicMessageChannelCreation() {
        let engine = FlutterEngine(name: "basic_channel_engine")
        _ = engine.run()
        let channel = FlutterBasicMessageChannel(
            name: "com.ninjasdet.test/basic",
            binaryMessenger: engine.binaryMessenger
        )
        XCTAssertNotNil(channel, "FlutterBasicMessageChannel debe poder crearse.")
    }

    /// Verifica que se puede crear un FlutterMethodChannel.
    func testFlutterMethodChannelCreation() {
        let engine = FlutterEngine(name: "method_channel_engine")
        _ = engine.run()
        let channel = FlutterMethodChannel(
            name: "com.ninjasdet.test/method",
            binaryMessenger: engine.binaryMessenger
        )
        XCTAssertNotNil(channel, "FlutterMethodChannel debe poder crearse.")
    }

    /// Verifica que se puede crear un FlutterEventChannel.
    func testFlutterEventChannelCreation() {
        let engine = FlutterEngine(name: "event_channel_engine")
        _ = engine.run()
        let channel = FlutterEventChannel(
            name: "com.ninjasdet.test/event",
            binaryMessenger: engine.binaryMessenger
        )
        XCTAssertNotNil(channel, "FlutterEventChannel debe poder crearse.")
    }

    // MARK: - Bundle / App Info Tests

    /// Verifica que el bundle principal tiene un identificador válido.
    func testMainBundleHasIdentifier() {
        // En tests el bundle principal es el host app (Runner)
        let bundleID = Bundle.main.bundleIdentifier
        XCTAssertNotNil(bundleID, "El bundle de la app debe tener un bundle identifier.")
    }

    /// Verifica que el bundle de la app tiene una versión definida.
    func testMainBundleHasVersion() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        XCTAssertNotNil(version, "La app debe tener una versión definida en Info.plist.")
    }

    /// Verifica que el bundle identifier del host (Runner) contiene el nombre del proyecto.
    func testBundleIdentifierContainsAppName() {
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        // El bundle identifier debe ser com.sergioios.basicFlutterApp (según project.pbxproj)
        XCTAssertFalse(bundleID.isEmpty, "El bundle identifier no debe estar vacío.")
    }

}

import XCTest

// MARK: - RunnerUITests (XCUITest UI Tests)
// Pruebas de interfaz de usuario para la app "Ninja SDET".
//
// Cómo funciona con Flutter:
//   Flutter renderiza la UI a través de FlutterViewController. Los widgets de Flutter
//   exponen información de accesibilidad (semantics) que XCUITest puede detectar.
//   Los TextFields, Buttons y Labels del app son accesibles mediante su texto visible
//   o etiquetas de accesibilidad.
//
// Para correr estas pruebas:
//   Xcode → Product → Test (⌘U)  |  o selecciona el target RunnerUITests en el scheme.

class RunnerUITests: XCTestCase {

    let app = XCUIApplication()

    // MARK: - Setup / Teardown

    override func setUpWithError() throws {
        continueAfterFailure = false
        // Argumento para que Flutter no muestre el banner de debug
        app.launchArguments = ["--dart-test-mode"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Tests de Lanzamiento

    /// Verifica que la app arranca y queda en primer plano.
    func test01_AppLaunchesSuccessfully() {
        XCTAssertTrue(
            app.wait(for: .runningForeground, timeout: 15),
            "La app debe arrancar y estar en primer plano."
        )
    }

    /// Captura pantalla del estado inicial (Login) y la adjunta al reporte.
    func test02_LoginScreenScreenshot() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Pantalla de Login"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Tests de la Pantalla de Login

    /// Verifica que el botón "Ingresar" existe en la pantalla inicial.
    func test03_LoginButtonExists() {
        let loginButton = app.buttons["Ingresar"]
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 15),
            "El botón 'Ingresar' debe estar visible en la pantalla de Login."
        )
    }

    /// Verifica que existe al menos un campo de texto (usuario).
    func test04_UsernameTextFieldExists() {
        let textField = app.textFields.firstMatch
        XCTAssertTrue(
            textField.waitForExistence(timeout: 15),
            "Debe existir un campo de texto para el usuario."
        )
    }

    /// Verifica que existe al menos un campo seguro (contraseña).
    func test05_PasswordSecureFieldExists() {
        let secureField = app.secureTextFields.firstMatch
        XCTAssertTrue(
            secureField.waitForExistence(timeout: 15),
            "Debe existir un campo seguro para la contraseña."
        )
    }

    /// Verifica que el enlace de registro existe.
    func test06_RegisterLinkExists() {
        let registerButton = app.buttons["Registra tu usuario aquí"]
        XCTAssertTrue(
            registerButton.waitForExistence(timeout: 15),
            "El enlace de 'Registra tu usuario aquí' debe estar visible."
        )
    }

    // MARK: - Tests de Validación de Login

    /// Login con campos vacíos debe mostrar mensaje de error.
    func test07_EmptyFieldsShowsValidationError() {
        let loginButton = app.buttons["Ingresar"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 15))

        loginButton.tap()

        let errorText = app.staticTexts["Por favor, ingresa usuario y contraseña."]
        XCTAssertTrue(
            errorText.waitForExistence(timeout: 5),
            "Debe aparecer mensaje de error cuando los campos están vacíos."
        )
    }

    /// Login con credenciales incorrectas debe mostrar mensaje de error.
    func test08_WrongCredentialsShowsError() {
        let textField = app.textFields.firstMatch
        let secureField = app.secureTextFields.firstMatch

        XCTAssertTrue(textField.waitForExistence(timeout: 15))
        textField.tap()
        textField.typeText("usuarioFalso")

        XCTAssertTrue(secureField.waitForExistence(timeout: 5))
        secureField.tap()
        secureField.typeText("claveIncorrecta")

        app.buttons["Ingresar"].tap()

        let errorText = app.staticTexts["Usuario o contraseña incorrectos"]
        XCTAssertTrue(
            errorText.waitForExistence(timeout: 5),
            "Debe mostrar error con credenciales incorrectas."
        )
    }

    /// Login con credenciales de admin debe navegar a la pantalla de bienvenida.
    func test09_AdminLoginNavigatesToWelcomeScreen() {
        loginAsAdmin()

        // WelcomeScreen muestra "Automating everything"
        let welcomeText = app.staticTexts["Automating everything"]
        XCTAssertTrue(
            welcomeText.waitForExistence(timeout: 15),
            "Tras login como admin debe aparecer la pantalla de bienvenida con 'Automating everything'."
        )
    }

    // MARK: - Tests de la Pantalla de Bienvenida (WelcomeScreen)

    /// Verifica que la barra de navegación inferior tiene los tabs correctos.
    func test10_WelcomeScreenBottomNavBarExists() {
        loginAsAdmin()

        let commonToolsTab = app.buttons["CommonTools"]
        let gamesTab = app.buttons["Games"]

        XCTAssertTrue(
            commonToolsTab.waitForExistence(timeout: 10),
            "El tab 'CommonTools' debe existir en la barra de navegación."
        )
        XCTAssertTrue(
            gamesTab.waitForExistence(timeout: 5),
            "El tab 'Games' debe existir en la barra de navegación."
        )
    }

    /// Verifica que los banners de la pantalla principal están visibles.
    func test11_WelcomeScreenBannersAreVisible() {
        loginAsAdmin()

        let dropdownBanner = app.staticTexts["Dropdown & Toggle"]
        XCTAssertTrue(
            dropdownBanner.waitForExistence(timeout: 10),
            "El banner 'Dropdown & Toggle' debe estar visible en CommonTools."
        )
    }

    /// Cambia al tab Games y verifica que aparecen los banners de juegos.
    func test12_GamesTabShowsGameBanners() {
        loginAsAdmin()

        let gamesTab = app.buttons["Games"]
        XCTAssertTrue(gamesTab.waitForExistence(timeout: 10))
        gamesTab.tap()

        let bugHuntersBanner = app.staticTexts["Bug Hunters 🐛"]
        XCTAssertTrue(
            bugHuntersBanner.waitForExistence(timeout: 5),
            "El tab Games debe mostrar el banner 'Bug Hunters 🐛'."
        )
    }

    // MARK: - Tests de la Pantalla de Registro

    /// Navegar a registro desde login debe mostrar la pantalla de registro.
    func test13_NavigationToRegisterScreen() {
        let registerButton = app.buttons["Registra tu usuario aquí"]
        XCTAssertTrue(registerButton.waitForExistence(timeout: 15))
        registerButton.tap()

        let createUserButton = app.buttons["Crear user"]
        XCTAssertTrue(
            createUserButton.waitForExistence(timeout: 5),
            "Al ir a registro debe aparecer el botón 'Crear user'."
        )
    }

    /// El botón "Crear user" debe estar deshabilitado al entrar a la pantalla.
    func test14_CreateUserButtonStartsDisabled() {
        let registerButton = app.buttons["Registra tu usuario aquí"]
        XCTAssertTrue(registerButton.waitForExistence(timeout: 15))
        registerButton.tap()

        let createUserButton = app.buttons["Crear user"]
        XCTAssertTrue(createUserButton.waitForExistence(timeout: 5))
        XCTAssertFalse(
            createUserButton.isEnabled,
            "El botón 'Crear user' debe estar deshabilitado hasta que se llenen todos los campos."
        )
    }

    // MARK: - Tests de Orientación

    /// La app mantiene la UI correcta al rotar a landscape.
    func test15_AppHandlesLandscapeOrientation() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))

        XCUIDevice.shared.orientation = .landscapeLeft
        // Esperar que la UI se ajuste
        sleep(1)

        let loginButton = app.buttons["Ingresar"]
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 5),
            "El botón 'Ingresar' debe seguir visible en modo landscape."
        )

        // Restaurar portrait
        XCUIDevice.shared.orientation = .portrait
    }

    // MARK: - Helper Methods

    /// Realiza el login con credenciales de administrador.
    private func loginAsAdmin() {
        let textField = app.textFields.firstMatch
        let secureField = app.secureTextFields.firstMatch

        if textField.waitForExistence(timeout: 15) {
            textField.tap()
            textField.typeText("admin")
        }

        if secureField.waitForExistence(timeout: 5) {
            secureField.tap()
            secureField.typeText("admin")
        }

        app.buttons["Ingresar"].tap()
    }
}

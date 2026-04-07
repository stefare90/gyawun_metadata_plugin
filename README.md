# 🧩 Gyawun Metadata Plugin - Template

Welcome to the official template for creating hot-swappable plugins for the **Gyawun** app.

This repository provides a complete environment to develop, test (both natively and via the `dart_eval` runtime), and compile metadata plugins. Once compiled, these plugins can be dynamically loaded into the Gyawun app to provide music metadata, search capabilities, and more.

---

## 📂 Project Structure

This project uses a layered testing architecture to ensure bytecode compatibility:

*   📁 **`lib/`**: **THE PLUGIN CORE.** Write your logic here in **pure Dart**.
    *   `segments/`: Suggested folder to organize interface implementations (Artist, Album, Search, etc.).
    *   `main.dart`: The entry point called by the host app to initialize the plugin and inject dependencies.
*   📁 **`test/unit/`**: **NATIVE DEBUGGING.** Standard Dart unit tests. Use this to verify logic, JSON parsing, and API calls with full native speed, breakpoints, and IDE debugging tools.
*   📁 **`test/integration/`**: **BYTECODE COMPATIBILITY.** These tests run against the compiled `plugin.evc` file using the `dart_eval` runtime. Essential for catching compiler-specific issues.
*   📁 **`tool/`**: Contains Dart scripts for compiling the plugin into bytecode.
*   📄 **`plugin.json`**: The plugin manifest containing metadata and permissions.

---

## 🚀 Development Workflow

### 1. Configure the Manifest
Open **`plugin.json`** and define your plugin's identity:

```json
{
  "version": "1.0.0",
  "name": "my_custom_provider",
  "author": "Your Name",
  "entryPoint": "getPlugin",
  "abilities": ["metadata", "search"],
  "pluginApiVersion": "1.0.0"
}
```

### 2. Implement the Logic (`lib/`)
Implement the interfaces provided by the SDK.
> **Important:** Code in `lib/` must be `dart_eval` compatible.

### 3. Unit Testing (`test/unit/`)
Verify your logic before compiling. Create tests here to mock API responses or use real one and validate model mapping.
```bash
dart test test/unit/plugin_test.dart
```
Use your IDE's debugger here to inspect variables and logic flow in a native environment.

---

## 📦 Compilation & Integration Testing

Once the native logic is stable, you must transform it into bytecode and verify it in the restricted runtime environment.

### 1. Compile to Bytecode
Use the provided tool to generate the `.evc` file:
```bash
dart run tool/build_plugin.dart
```
This will generate the **`plugin.evc`** file in the project root.

### 2. Integration Testing (`test/integration/`)
Run integration tests to ensure the bytecode is interpreted correctly by the `dart_eval` engine:
```bash
dart test test/integration/plugin_test.dart
```

---

## 📦 Final Export

When both Unit and Integration tests pass:

1. Ensure `plugin.evc` and `plugin.json` are up to date.
2. Create a `.zip` archive containing these two files (and any required assets).
3. Load the zip into the Gyawun app.

---

## 🛠 Troubleshooting
If integration tests fail with "nonexistent external function" errors:
- Verify that SDK interfaces are annotated with `@Bind(bridge: true)`.
- Ensure the `.eval.dart` files in the SDK include manual constructor registrations (e.g., `registerBridgeFunc` with the dot suffix `'IMetadataPlugin.'`).
- Ensure `Future` methods in the bridge are manually patched to use `async/await` and unbox results via `(result as $Value).$value`.
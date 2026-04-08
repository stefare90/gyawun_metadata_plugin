# 🧩 Gyawun Metadata Plugin - Template

Welcome to the official template for creating hot-swappable plugins for the **Gyawun** app.

This repository provides a complete environment to develop, test, and compile metadata plugins. Once compiled, these plugins can be dynamically loaded into the Gyawun app to provide music metadata, search capabilities, and more.

---

## 📂 Project Structure

| Path | Purpose |
| :--- | :--- |
| 📁 **`lib/`** | **Plugin Core.** Logic for fetching and parsing metadata. |
| 📁 **`test/mock_api/`** | **Logic & Bridge Tests.** Fast, deterministic tests using `mocktail`. Tests both the Native plugin and the `dart_eval` Bytecode side-by-side. |
| 📁 **`test/real_api/`** | **E2E Validation.** Tests against live servers (e.g., Musicbrainz). Also tests both Native and Bytecode environments. |
| 📁 **`tool/`** | **Build System.** Scripts to compile Dart into `.evc` bytecode. |
| 📄 **`plugin.json`** | **Manifest.** Metadata, permissions, and entry point definitions. |

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
  "abilities":["metadata", "search"],
  "pluginApiVersion": "1.0.0"
}
```

### 2. Implement the Logic (`lib/`)
Implement the interfaces provided by the SDK.
> **Important:** Code in `lib/` must be `dart_eval` compatible. Avoid the `late` keyword (use nullable variables with getters instead) and always use `extends` rather than `implements` for SDK Bridge classes.

---

## 📦 Compilation & Testing

Because our test suites evaluate both the Native plugin and the `dart_eval` engine in parallel, **you must compile the plugin before running the tests.**

### 1. Compile to Bytecode
Use the provided tool to generate the `.evc` file. Run this every time you change the code in `lib/`:
```bash
dart run tool/build_plugin.dart
```
This generates the **`plugin.evc`** file in the project root.

### 2. Run Mock API Tests (Daily Development)
Verify your logic, JSON parsing, and bytecode compatibility using simulated API responses. This is extremely fast and won't trigger server rate limits.
```bash
dart test test/mock_api/
```
*Tip: You can use your IDE's debugger on the "Native" test groups within these files to inspect variables in real-time.*

### 3. Run Real API Tests (Pre-Release Validation)
Before publishing your plugin, ensure the external services are still responding with the expected data structures:
```bash
dart test test/real_api/
```

---

## 📦 Final Export

When both Mock and Real API tests pass successfully:

1. Ensure `plugin.evc` and `plugin.json` are up to date.
2. Create a `.zip` archive containing these two files (and any required assets).
3. Load the zip into the Gyawun app.

---
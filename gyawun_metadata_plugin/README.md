
# 🧩 Gywuan Metadata Plugin - Template

Welcome to the official template for creating hot-swappable plugins for the **Gywuan** app.

This repository provides everything you need to develop, test locally (with native debugging), and compile a plugin to fetch music metadata or audio sources, which can then be dynamically loaded into the main app.
---
## 📂 Project Structure

This project uses a split architecture to guarantee the best possible Developer Experience (DX):

*   📁 **`lib/`**: **YOUR PLUGIN.** Here you will write the plugin logic in **pure Dart**. This is the code that will be compiled and dynamically loaded.
*   📁 **`debug/`**: **THE TEST ENVIRONMENT.** A complete, pre-configured Flutter app that directly imports your plugin from the `lib/` folder. It allows you to run an emulator, use breakpoints, hot-reload, and test the plugin natively before compiling it.
*   📄 **`plugin.json`**: Your plugin's manifest. It contains the metadata and permissions read by the main app to integrate your module.
*   📄 **`build_plugin.sh`**: The magic script that compiles your code into bytecode (`.evc`) compatible with the Gywuan app engine.
---
## 🚀 How to Develop Your Plugin

### 1. Initial Setup
Make sure you have [Dart](https://dart.dev/get-dart) and [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
Open the **`plugin.json`** file and fill in the details of your new plugin:

```json
{
  "version": "1.0.0",
  "name": "my_custom_provider",
  "author": "Your Name",
  "description": "A brief description of the plugin's functionality.",
  "entryPoint": "MyCustomProvider",
  "apis":["webview", "localstorage", "timezone"],
  "abilities": ["authentication", "scrobbling", "metadata", "audioSource"],
  "repository": "https://github.com/your-username/your-repo",
  "pluginApiVersion": "1.0.0"
}
```
**Understanding the manifest fields:**
*   **`name`**: Must be alphanumeric, using only hyphens or underscores (no spaces).
*   **`entryPoint`**: The exact class name of your plugin (e.g., `MusicBrainzProvider`) that the host app needs to instantiate.
*   **`apis`**: The host features your plugin needs access to (e.g., `webview` for logins, `localstorage` to save tokens).
*   **`abilities`**: What your plugin actually provides to the app (e.g., `metadata` if it fetches track info, `audioSource` if it provides playback links).
*   **`pluginApiVersion`**: The version of the Gywuan Shared API your plugin was built against.

### 2. Develop the Logic (`lib/`)
Open the `lib/` folder and expand or implement the required interfaces. 
*   You can add pure Dart packages (e.g., `http`, `html_unescape`) to the main `pubspec.yaml` by running `dart pub add <package_name>`.
*   Write your API calls and parsing logic here.

### 3. Test and Debug (`debug/`)
There is no need to compile the plugin into bytecode after every change! To test your code:
1. Open a terminal and navigate into the debug folder: `cd debug`
2. Fetch dependencies: `flutter pub get`
3. Run the test app (via VS Code, Android Studio, or CLI: `flutter run`).

The debug app will import your code from `lib/` in real-time. You will be able to set breakpoints, inspect JSON responses, and ensure everything works perfectly in a real Flutter environment.

---

## 📦 Build and Export

When your plugin works flawlessly in the `debug/` environment, it's time to generate the distributable file.

1. Go back to the root folder of the project:
   ```bash
   cd ..
   ```
2. Make the script executable (only required the first time on Mac/Linux):
   ```bash
   chmod +x build_plugin.sh
   ```
3. Run the build script:
   ```bash
   ./build_plugin.sh
   ```

#### ⚙️ What the script does

The build script performs the following steps automatically:

- Ensures dart_eval is installed and available globally
- Cleans up previous build artifacts (plugin_output.evc and .zip if present)
- Compiles the contents of lib/ into plugin_output.evc (EVAL Bytecode)
- Verifies that plugin.json exists in the project root
- Packages everything into a distributable archive

#### 📦 Final Result

After the script completes successfully, you will find:

gywuan_plugin_build.zip → ready-to-distribute package containing:
plugin_output.evc (the compiled logic engine)
plugin.json (the registration metadata)

You can now directly upload or load this .zip file into the Gywuan app using the hot-swap system. 🎉

---

## 🧪 Unit Testing
If you want to write automated tests for your JSON parsing or internal logic, place them in the `test/` folder of the main root.
You can easily run them with:
```bash
dart test
```
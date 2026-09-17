# 🧩 Gyawun Metadata Plugin - Template

Welcome to the official template for creating hot-swappable plugins for the **Gyawun** app ecosystem.

This repository provides a complete environment to develop, test, and compile metadata plugins. Once compiled into bytecode, these plugins can be dynamically loaded into the host app as compressed `.zip` packages to provide music metadata, user libraries, browse sections, search capabilities, and more.

---

## 📂 Project Structure

| Path | Purpose |
| :--- | :--- |
| 📁 **`lib/`** | **Plugin Core.** Logic for fetching and parsing metadata. `lib/main.dart` exposes `getPlugin`. |
| 📁 **`test/mock_api/`** | **Logic & Bridge Tests.** Fast, deterministic tests using `mocktail`. Tests both Native and `dart_eval` Bytecode environments side-by-side. |
| 📁 **`test/real_api/`** | **E2E Validation.** Tests against live external API servers. Also tests both Native and Bytecode environments.|
| 📁 **`tool/`** | **Build System.** `build_plugin.dart` compiles Dart sources into `.evc` bytecode; `package_plugin.dart` compiles and bundles `plugin.evc` + `plugin.json` into `plugin.zip`. |
| 📄 **`plugin.json`** | **Manifest.** Plugin identity, capabilities, and SDK compatibility metadata. |

---

## 🚀 Development Workflow

### 1. Configure the Manifest (`plugin.json`)
Open **`plugin.json`** and define your plugin's metadata:

```json
{
  "id": "org.gyawun.musicbrainz",
  "packageId": "gyawun_metadata_plugin",
  "type": "metadata",
  "name": "MusicBrainz & ListenBrainz",
  "version": "1.0.0",
  "pluginSdkVersion": "1.0.0",
  "author": "Your Name / Organization",
  "description": "Metadata, recommendations, and user library provided by MusicBrainz and ListenBrainz.",
  "repository": "https://github.com/your_org/your_plugin_repo"
}
```

#### Manifest Fields Reference

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `String` | Unique plugin identifier using reverse-domain notation (e.g. `org.gyawun.spotify`). |
| `packageId` | `String` | The Dart package name used internally by `dart_eval` (must match `name` in `pubspec.yaml`). |
| `type` | `String` | Plugin type contract (e.g. `metadata` or `audioSource`). |
| `name` | `String` | Human-readable plugin name displayed in the Host App UI. |
| `version` | `String` | Plugin release version (semver format). |
| `pluginSdkVersion` | `String` | Version of `gyawun_metadata_sdk` this plugin was compiled against (used for host compatibility checks). |
| `author` | `String` | Author or organization name. |
| `description` | `String` | Brief summary of the plugin's features and sources. |
| `repository` | `String` | Public GitHub repository URL (used by the Host App to check for updates). |

---

## 2. Implement the Logic (`lib/`)
Implement the interfaces provided by the SDK.

### Implemented Interfaces
- **`IAlbum`**: Album and release-group fetching, tracks retrieval, cover art lookup via Cover Art Archive.
- **`IArtist`**: Artist profile, genres, wikidata image integration, discography and release-groups.
- **`IBrowse`**: Curated/algorithmic recommendations and radios via ListenBrainz API.
- **`ITrack`**: Track details and radio discovery. Embedded album metadata provides direct cover art images from Cover Art Archive.
- **`IUser` / `IAuth`**: ListenBrainz token authentication and personal library synchronization.
- **`ISearch`**: Search functionality querying MusicBrainz live web services.

#### ⚠️ Essential SDK Rules & Entry Point Contract:
1. **Entry Point Contract**: `lib/main.dart` **must** export a top-level function with the exact signature:
   ```dart
   IMetadataPlugin getPlugin(HostEnv hostEnv) {
     return MusicbrainzPlugin(hostEnv: hostEnv);
   }
   ```
2. **`dart_eval` Compatibility**:
   - Do **NOT** use `late` variables inside plugin classes.
   - Do **NOT** perform nullable type casts like `as Map?` on dynamic JSON objects.
   - Use standard `for-in` loops with explicit list typing before iteration.
   - Always `extend` rather than `implement` SDK Bridge classes.
   - **Explicit `Map` Casting**: Always cast dynamic JSON objects to `Map` (`final Map map = dynamicObj as Map;`) before invoking `Map` methods (e.g. `.containsKey()`) to prevent internal `$Map` wrapper failures in `dart_eval`.
   - **No `try/catch` around `await`**: in the `dart_eval` bytecode sandbox a `try/catch` wrapping an `await` corrupts the async frame (`type '$null' is not a subtype of type '$Future<dynamic>'`). Prefer non-throwing helpers (e.g. `HostTools.fetchApiOrNull`) and status/shape checks for graceful degradation.

---

## 📦 Compilation & Testing

Because our test suites evaluate both the Native plugin and the `dart_eval` bytecode engine in parallel, **you must compile the plugin before running the tests.**

### 1. Compile to Bytecode
Run the build script to generate the `.evc` bytecode file:
```bash
dart run tool/build_plugin.dart
```
This generates the **`plugin.evc`** file in the project root.

### 2. Run Mock API Tests (Daily Development)
Verify your logic, JSON parsing, and bytecode compatibility using simulated API responses:
```bash
dart test test/mock_api/
```

### 3. Run Real API Tests (Pre-Release Validation)
Verify external live services before publishing:
```bash
dart test test/real_api/
```

---

## 📦 Exporting & Packaging for Distribution

When both Mock and Real API tests pass successfully, run the packaging tool from the project root:

```bash
# from the gyawun_metadata_plugin/ directory
dart run tool/package_plugin.dart
```

It compiles `lib/` into `plugin.evc` and then packages `plugin.evc` + `plugin.json` into `plugin.zip`, with **both files at the archive root** (no subfolder) — exactly the layout the Host App expects. The ZIP is written in pure Dart (stored, no compression), so **no external `zip`/`python` tool is required** on any OS.

If you only need the bytecode (e.g. before running the test suites), use:

```bash
dart run tool/build_plugin.dart   # generates plugin.evc only
```

**Distribution Options**:
   - **Local Import**: Load the `.zip` directly into the Host App using the File Picker.
   - **GitHub Release**: Attach the `.zip` archive to a GitHub Release in your repository. The Host App will automatically discover and download it via the GitHub REST API!
---
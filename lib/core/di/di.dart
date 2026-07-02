import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

/// Same DI entry point pattern as the reference architecture:
/// `injectable` scans `@injectable` / `@module` / `@Injectable(as: ...)`
/// annotations at build time and generates `di.config.dart`.
///
/// IMPORTANT: `di.config.dart` in this Phase 1 skeleton is a hand-authored
/// placeholder (only the two `@module` providers exist so far: `Dio` and
/// `AssetBundle`). Once feature modules start adding `@injectable` classes
/// (Phase 2+), regenerate it for real with:
///   flutter pub run build_runner build --delete-conflicting-outputs
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();

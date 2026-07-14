// HAND-AUTHORED BOOTSTRAP PLACEHOLDER — NOT machine-generated.
//
// This file normally comes from `injectable_generator` via build_runner.
// It is hand-written here, in the same shape the generator produces, purely
// so the Phase 1 foundation compiles and runs without requiring the Flutter
// toolchain to be run first. It only wires up the two `@module` providers
// that exist at this stage (Dio, AssetBundle).
//
// Regenerate for real as soon as the first `@injectable`/`@Injectable(as:)`
// class is added (Phase 2+):
//   flutter pub run build_runner build --delete-conflicting-outputs

// ignore_for_file: type=lint
// coverage:ignore-file

import 'package:dio/dio.dart' as _i361;
import 'package:flutter/services.dart' as _i398;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'asset_bundle_module.dart' as _i762;
import 'network_module.dart' as _i527;

extension GetItInjectableX on _i174.GetIt {
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    final assetBundleModule = _$AssetBundleModule();
    gh.singleton<_i361.Dio>(() => networkModule.provideDio());
    gh.singleton<_i398.AssetBundle>(() => assetBundleModule.provideAssetBundle());
    return this;
  }
}

// `@module` classes must be abstract (injectable's own requirement), so
// they cannot be instantiated directly — the generator always creates a
// concrete synthetic subclass like these two to call the provider methods.
class _$NetworkModule extends _i527.NetworkModule {}

class _$AssetBundleModule extends _i762.AssetBundleModule {}

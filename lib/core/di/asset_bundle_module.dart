import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Carried over from the reference architecture unchanged. Registers the
/// app's [AssetBundle] so local datasources (bundled JSON, etc.) can be
/// constructor-injected instead of calling `rootBundle` directly.
@module
abstract class AssetBundleModule {
  @singleton
  AssetBundle provideAssetBundle() => rootBundle;
}

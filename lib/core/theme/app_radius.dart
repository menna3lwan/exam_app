import 'package:flutter/material.dart';

/// Border-radius tokens.
///
/// `input` (4px) and `pill` (fully rounded) were read directly off the
/// Figma "Login" screen: text fields use a 4px border radius, the primary
/// button is a fully rounded pill.
class AppRadius {
  AppRadius._();

  static const double input = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;

  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(input));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pill));
}

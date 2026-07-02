import 'package:flutter/material.dart';

/// Icon mapping.
///
/// The Figma "Design system" page's Icons frame uses generic outline
/// glyphs (back, check, home, search, person, cart, pin, etc.) without
/// exported SVG assets attached. Until icon assets/an icon font are
/// provided, this maps semantic names to Material icons so call sites
/// don't reference `Icons.*` directly and can be swapped for custom SVGs
/// later without touching feature code.
class AppIcons {
  AppIcons._();

  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData check = Icons.check;
  static const IconData home = Icons.home_outlined;
  static const IconData search = Icons.search;
  static const IconData person = Icons.person_outline;
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData pin = Icons.location_on_outlined;
  static const IconData close = Icons.close;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
}

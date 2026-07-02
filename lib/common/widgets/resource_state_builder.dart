import 'package:flutter/material.dart';

import '../../core/base/resources.dart';

/// Generic shared widget: switches on a [Resources] status the same way
/// the reference architecture's `home_view.dart` does inline, so feature
/// screens don't repeat that switch statement themselves.
///
/// Purely presentational plumbing — it has no knowledge of any feature,
/// API, or business logic, which is why it belongs in `common/` and not a
/// feature's `presentation/` folder.
class ResourceStateBuilder<T> extends StatelessWidget {
  final Resources<T> resource;
  final Widget Function(BuildContext context, T data) onSuccess;
  final WidgetBuilder? onLoading;
  final Widget Function(BuildContext context, String? message)? onError;
  final WidgetBuilder? onInit;

  const ResourceStateBuilder({
    super.key,
    required this.resource,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onInit,
  });

  @override
  Widget build(BuildContext context) {
    switch (resource.status) {
      case Status.success:
        final data = resource.data;
        if (data == null) {
          return onError?.call(context, resource.message) ?? const SizedBox.shrink();
        }
        return onSuccess(context, data);
      case Status.loading:
        return onLoading?.call(context) ??
            const Center(child: CircularProgressIndicator());
      case Status.error:
        return onError?.call(context, resource.message) ??
            Center(child: Text(resource.message ?? 'Something went wrong'));
      case Status.init:
        return onInit?.call(context) ?? const SizedBox.shrink();
    }
  }
}

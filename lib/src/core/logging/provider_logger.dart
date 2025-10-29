import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Observes provider lifecycle events to aid debugging and analytics.
class ProviderLogger extends ProviderObserver {
  const ProviderLogger();

  @override
  void didAddProvider(ProviderBase<dynamic> provider, Object? value, ProviderContainer container) {
    super.didAddProvider(provider, value, container);
  }

  @override
  void didUpdateProvider(ProviderBase<dynamic> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void didDisposeProvider(ProviderBase<dynamic> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
  }
}

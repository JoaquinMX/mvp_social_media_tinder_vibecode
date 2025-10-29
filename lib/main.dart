import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/app.dart';
import 'src/core/logging/provider_logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: const [ProviderLogger()],
      child: const GroupSwipeApp(),
    ),
  );
}

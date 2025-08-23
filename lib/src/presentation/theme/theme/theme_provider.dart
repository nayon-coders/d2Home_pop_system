import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_desktop/src/presentation/theme/theme/theme.dart';

final appThemeProvider = ChangeNotifierProvider<AppTheme>.internal(
      (ref) => throw UnimplementedError(),
  name: 'appThemeProvider',
  dependencies: null,
  debugGetCreateSourceHash: () => _appThemeHash()!,
   allTransitiveDependencies: null,
);

// The required debug hash function:
String? _appThemeHash() => r'0f5e6b3c9d7a1b2c3d4e5f6a7b8c9d0e';

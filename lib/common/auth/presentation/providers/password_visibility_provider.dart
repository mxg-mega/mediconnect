import 'package:flutter_riverpod/flutter_riverpod.dart';

// Individual providers for specific password fields
final passwordVisibilityProvider1 = StateProvider<bool>((ref) => false);
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => false);

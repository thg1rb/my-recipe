import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropDownStateProvider = StateProvider.family<bool, String>((ref, id) => false);
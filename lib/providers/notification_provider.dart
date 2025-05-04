import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/services/noti_service.dart';

// Provider to track if notifications are enabled
final isNotificationEnabled = StateProvider<bool>((ref) => true);

// Provider for the NotiService instance
final notiServiceProvider = Provider<NotiService>((ref) => NotiService());

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_recipe/services/notification_content_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  // Strategy Pattern - Singleton instance
  static final NotiService _instance = NotiService._internal();

  // Factory constructor to return the same instance
  factory NotiService() {
    return _instance;
  }

  // Private constructor for singleton
  NotiService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationContentService _notiContentService =
      NotificationContentService();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Initialize the notification service
  Future<void> initNotifiction() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Notification plugin initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await notificationsPlugin.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap if needed
      },
    );

    // Schedule the daily notifications
    await scheduleDailyNotifications();
    _isInitialized = true;
  }

  // Notification details
  NotificationDetails get _defaultNotiDetails {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_notifications_channel',
        'Daily Notifications',
        channelDescription: 'Channel for daily scheduled notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // Schedule all daily notifications
  Future<void> scheduleDailyNotifications() async {
    await _scheduleNotificationAtTime(7, 00); // 7:00 AM
    await _scheduleNotificationAtTime(12, 0); // 12:00 PM
    await _scheduleNotificationAtTime(17, 0); // 5:00 PM
  }

  // Helper method to schedule at specific time
  Future<void> _scheduleNotificationAtTime(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    final content = _notiContentService.randomContent;

    // Create scheduled date
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      _generateNotificationId(hour, minute),
      content.title,
      content.body,
      scheduledDate,
      _defaultNotiDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Generate unique ID based on time
  int _generateNotificationId(int hour, int minute) {
    return hour * 100 + minute; // 700 for 7:00, 1200 for 12:00, etc.
  }

  // Show immediate notification (for testing)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(id, title, body, _defaultNotiDetails);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    _isInitialized = false;
    await notificationsPlugin.cancelAll();
  }
}

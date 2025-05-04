class NotificationContent {
  final String _title;
  final String _body;

  NotificationContent({required String title, required String body})
    : _title = title,
      _body = body;

  String get title => _title;
  String get body => _body;
}

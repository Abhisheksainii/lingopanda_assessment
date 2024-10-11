class DateTimeUtils {
  DateTimeUtils._();

  static String timeAgo(DateTime pastTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(pastTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      if (difference.inDays == 1) {
        return '${difference.inDays} day ago';
      }
      return '${difference.inDays} days ago';
    }
  }
}

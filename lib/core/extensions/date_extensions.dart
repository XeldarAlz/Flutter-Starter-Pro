import 'package:intl/intl.dart';

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Format date as 'MMM dd, yyyy' (e.g., 'Jan 01, 2024')
  String get formatted => DateFormat('MMM dd, yyyy').format(this);

  /// Format date as 'dd/MM/yyyy' (e.g., '01/01/2024')
  String get formattedShort => DateFormat('dd/MM/yyyy').format(this);

  /// Format date as 'EEEE, MMMM dd, yyyy' (e.g., 'Monday, January 01, 2024')
  String get formattedLong => DateFormat('EEEE, MMMM dd, yyyy').format(this);

  /// Format time as 'HH:mm' (e.g., '14:30')
  String get formattedTime => DateFormat('HH:mm').format(this);

  /// Format time as 'hh:mm a' (e.g., '02:30 PM')
  String get formattedTime12 => DateFormat('hh:mm a').format(this);

  /// Format date and time
  String get formattedDateTime => DateFormat('MMM dd, yyyy HH:mm').format(this);

  /// Format as ISO 8601 string
  String get isoFormat => toIso8601String();

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is this year
  bool get isThisYear => year == DateTime.now().year;

  /// Get the start of the day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get the start of the week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Get the end of the week (Sunday)
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6)).endOfDay;

  /// Get the start of the month
  DateTime get startOfMonth => DateTime(year, month);

  /// Get the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get relative time string (e.g., '2 hours ago', 'in 3 days')
  String get relative {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      // Future
      final futureDiff = difference.abs();
      if (futureDiff.inDays > 365) {
        return 'in ${(futureDiff.inDays / 365).floor()} years';
      } else if (futureDiff.inDays > 30) {
        return 'in ${(futureDiff.inDays / 30).floor()} months';
      } else if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} days';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hours';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minutes';
      } else {
        return 'in a moment';
      }
    } else {
      // Past
      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} years ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} months ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Calculate age from birth date
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days;

    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }

    return result;
  }
}


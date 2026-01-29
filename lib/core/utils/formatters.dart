import 'package:intl/intl.dart';

/// Formatting utilities
abstract class Formatters {
  /// Format currency
  static String currency(
    double amount, {
    String symbol = r'$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(amount);
  }

  /// Format compact currency (e.g., $1.2K, $3.5M)
  static String compactCurrency(
    double amount, {
    String symbol = r'$',
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      locale: locale,
    );
    return formatter.format(amount);
  }

  /// Format number with thousand separators
  static String number(double value, {int decimalDigits = 0}) {
    final formatter = NumberFormat.decimalPattern()
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  /// Format compact number (e.g., 1.2K, 3.5M)
  static String compactNumber(double value) {
    return NumberFormat.compact().format(value);
  }

  /// Format percentage
  static String percentage(double value, {int decimalDigits = 1}) {
    final formatter = NumberFormat.percentPattern()
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(value / 100);
  }

  /// Format phone number
  static String phoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    return value;
  }

  /// Format credit card number
  static String creditCard(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Mask credit card number (show last 4 digits)
  static String maskCreditCard(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 4) return value;

    final masked = '**** **** **** ${digits.substring(digits.length - 4)}';
    return masked;
  }

  /// Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration
  static String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format duration as time (HH:MM:SS)
  static String durationAsTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /// Format ordinal number (1st, 2nd, 3rd, etc.)
  static String ordinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Format as title case
  static String titleCase(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Format as sentence case
  static String sentenceCase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Format as slug
  static String slug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Format initials from name
  static String initials(String name, {int count = 2}) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    final initials = words
        .take(count)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return initials;
  }

  /// Format list as readable string
  static String listToString(List<String> items, {String conjunction = 'and'}) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items[0]} $conjunction ${items[1]}';

    final allButLast = items.take(items.length - 1).join(', ');
    return '$allButLast, $conjunction ${items.last}';
  }
}

import 'package:logger/logger.dart';

class LogService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void i(dynamic message) => _logger.i(message); // info
  static void d(dynamic message) => _logger.d(message); // debug
  static void e(dynamic message) => _logger.e(message); // error
  static void w(dynamic message) => _logger.w(message); // warning
}

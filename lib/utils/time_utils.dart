class TimeUtils {
  static String convertStringToDuration(String secondsString) {
    double seconds;
    try {
      seconds = double.parse(secondsString);
      var videotimeinSec = Duration(
          microseconds: (seconds * Duration.microsecondsPerSecond).round());
      List<String> parts = (videotimeinSec.toString()).split('.');
      String formattedDuration = parts[0];
      return formattedDuration;
    } on FormatException {
      throw Exception("Invalid input: '$secondsString' is not a valid number");
    }
  }

  static String formatMilliseconds(num milliseconds) {
    int seconds = (milliseconds / 1000).round();
    int minutes = (seconds / 60).floor();
    seconds %= 60;
    int hours = (minutes / 60).floor();
    minutes %= 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatVideoTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

// String formatMilliseconds(int milliseconds) {
//   Duration duration = Duration(milliseconds: milliseconds);
//   String twoDigits(int n) => n.toString().padLeft(2, '0');
//   final minutes = twoDigits(duration.inMinutes.remainder(60));
//   final seconds = twoDigits(duration.inSeconds.remainder(60));
//   return "$minutes:$seconds";
// }
}

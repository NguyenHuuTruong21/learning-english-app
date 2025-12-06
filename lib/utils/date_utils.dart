// lib/utils/date_utils.dart

/// Utilities for working with epoch milliseconds and simple date calculations.
///
/// No external packages required — uses only `dart:core`.
/// Keep in mind: 1 day = 86_400_000 milliseconds.
const int millisPerDay = 86400000;

int nowMillis() => DateTime.now().millisecondsSinceEpoch;

/// Return a DateTime from millis (local).
DateTime dateTimeFromMillis(int millis) =>
    DateTime.fromMillisecondsSinceEpoch(millis).toLocal();

/// Return epoch millis for the start of the day (00:00:00) of the given [dt].
/// If [dt] is null, uses the current time.
int startOfDayMillis([DateTime? dt]) {
  final d = (dt ?? DateTime.now()).toLocal();
  final start = DateTime(d.year, d.month, d.day);
  return start.millisecondsSinceEpoch;
}

/// Compute difference in whole days between two epoch millis values:
/// result = floor((aMillis - bMillis) / millisPerDay)
/// - positive when aMillis is after bMillis
/// - zero when same calendar day (within 24h window, depending on exact times)
int daysBetweenMillis(int aMillis, int bMillis) {
  final diff = aMillis - bMillis;
  // use floor to mimic integer-day difference (like (now - last)/86400000)
  return (diff / millisPerDay).floor();
}

/// Returns true if [lastMillis] is exactly one day before [referenceMillis]
/// (i.e., difference in whole days == 1). If [referenceMillis] is omitted, uses now.
bool isNextDay(int lastMillis, [int? referenceMillis]) {
  final ref = referenceMillis ?? nowMillis();
  return daysBetweenMillis(ref, lastMillis) == 1;
}

/// Returns true if both epoch millis are on the same local calendar day.
bool isSameDay(int aMillis, int bMillis) =>
    startOfDayMillis(DateTime.fromMillisecondsSinceEpoch(aMillis)) ==
        startOfDayMillis(DateTime.fromMillisecondsSinceEpoch(bMillis));

/// Simple formatter: "yyyy-MM-dd HH:mm"
String formatMillis(int millis) {
  final dt = dateTimeFromMillis(millis);
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$y-$m-$d $hh:$mm';
}

/// Return a short date "yyyy-MM-dd"
String formatDateShort(int millis) {
  final dt = dateTimeFromMillis(millis);
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/*
Usage examples:

import 'utils/date_utils.dart' as du;

final now = du.nowMillis();
final startToday = du.startOfDayMillis();
final days = du.daysBetweenMillis(now, lastStudyMillis);
if (du.isNextDay(lastStudyMillis)) {
  // increment streak
}
final pretty = du.formatMillis(now);
*/

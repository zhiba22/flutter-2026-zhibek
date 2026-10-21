const Duration meetingLength = Duration(hours: 2);

sealed class Countdown {
  const Countdown();

  factory Countdown.of(DateTime when, DateTime now) {
    final diff = when.difference(now);
    if (!diff.isNegative) return Upcoming(diff);
    final elapsed = diff.abs();
    if (elapsed < meetingLength) return Started(elapsed);
    return const Ended();
  }
}

class Upcoming extends Countdown {
  const Upcoming(this.timeLeft);
  final Duration timeLeft;
}

class Started extends Countdown {
  const Started(this.elapsed);
  final Duration elapsed;
}

class Ended extends Countdown {
  const Ended();
}

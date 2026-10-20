sealed class Countdown {
  const Countdown();
}

class CountdownUpcoming extends Countdown {
  final Duration remaining;
  const CountdownUpcoming(this.remaining);
}

class CountdownStarted extends Countdown {
  final Duration elapsed;
  const CountdownStarted(this.elapsed);
}

class CountdownEnded extends Countdown {
  const CountdownEnded();
}
class Ticker {
  const Ticker({this.duration});
  final Duration duration;

  Stream<int> tick({int ticks}) {
    return Stream.periodic(
            duration ?? const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

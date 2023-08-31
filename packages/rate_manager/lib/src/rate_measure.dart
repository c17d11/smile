class RateMeasure {
  int requests = 1;
  late Stopwatch sw;

  RateMeasure() {
    sw = Stopwatch()..start();
  }
}

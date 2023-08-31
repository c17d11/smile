class RateLimit {
  int calls;
  int reservedCalls;
  Duration duration;

  RateLimit(this.calls, this.reservedCalls, this.duration);
}

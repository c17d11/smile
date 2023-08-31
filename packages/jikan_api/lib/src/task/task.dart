abstract class Task<T> {
  Stream<double> run();
  T getResult();
}

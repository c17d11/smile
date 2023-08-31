abstract class Api<T, T2> {
  Future<T2> call(T arg);
}

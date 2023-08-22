/// This type is basically a wrapper over a future that could throw.
/// If we await this.asValue(), we could either get a value, or null.
/// If we await this.asError(), we could either get an error, or null.
/// The <T> is only here for me to annotate what the type of value produced
/// by this future is. In a previous impl, this was a Future<Result<T>>, 
/// with Result from the async package, but that can't be sent over isolates.
/// So, I resorted to writing this using a map.
typedef FutureResult<T> = Future<Map<String, dynamic>>;

FutureResult<T> futureResult<T>(Future<T> future) async {
  try {
    dynamic v = await future;

    // this is because, if the next line is true, v is not necessarily a
    // map, but could be some subtype of it, which is the case when we do
    // invokeMapMethod. we get a CastMap, which subtypes Map and is internal
    // to dart. CastMap cant be sent over isolates, so i recreate it as a map
    if (v is Map) v = v.map((key, value) => MapEntry(key, value));

    return {'v': v};
  } catch (e) {
    return {'e': e};
  }
}

extension FutureResultExtension<T> on FutureResult<T> {
  Future<T?> asValue() async => (await this)['v'];
  Future<Exception?> asError() async => (await this)['e'];
}
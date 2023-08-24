import 'package:async/async.dart';

Future<Map<String, dynamic>> futureToResultMap<T>(Future<T> Function() future) async {
  try {
    T v = await future();
    if (v is Map) v = v.map((key, value) => MapEntry(key, value)) as T;

    // this is because, if true, v is not necessarily a
    // map, but could be some subtype of it, which is the case when we do
    // invokeMapMethod. we get a CastMap, which subtypes Map and is internal
    // to dart. CastMap cant be sent over isolates, so i recreate it as a map

    return {'v': v};
  } catch (e) {
    return {'e': e.toString()};
  }
}

Result<T> mapToResult<T>(Map<String, dynamic> map) =>
  map['v'] != null ? Result.value(map['v']!) : Result.error(map['e']!);

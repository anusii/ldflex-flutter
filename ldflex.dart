@JS('ldflex')
library ldflex;

import 'package:js/js.dart';
import 'dart:async';
import 'dart:js_util';
import 'dart:js';

@JS('createPath')
external JsObject _createPath(String path, List<String> sources, dynamic options);

JsObject createPath(String path, List<String> sources, Object options) {
  return _createPath(path, sources, jsify(options));
}

class LDflexEntity {
  // JavaScriptObject
  late dynamic _path;
  LDflexEntity(String path, List<String> sources, Object options) {
    _path = createPath(path, sources, options);
  }
  LDflexEntity.fromPath(dynamic path) {
    _path = path;
  }
  LDflexEntity operator [](String index) {
    return LDflexEntity.fromPath(getProperty(_path, index));
  }
  call(String method, List<Object?> args) {
    return LDflexEntity.fromPath(callMethod(_path, method, args));
  }
  Future<LDflexEntity?> resolve() async {
      Iterable<LDflexEntity> entities = await resolveIterator();
      return entities.isEmpty ? null : entities.elementAt(0);
  }
  Future<Iterable<LDflexEntity>> resolveIterator() async {
    List<dynamic> entities = await promiseToFuture(callMethod(_path, 'toArray', []));
    return entities.map((path) => LDflexEntity.fromPath(path));
  }
  String toString() {
    return callMethod(_path, 'toString', []);
  }
}

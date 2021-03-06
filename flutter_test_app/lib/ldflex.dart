@JS('ldflex')
library ldflex;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:js/js.dart';
import 'dart:async';
import 'dart:js_util';
import 'dart:js';

@JS('createPath')
external JsObject _createPath(
    String path, List<String> sources, dynamic options);

@JS('Symbol.asyncIterator')
external JsObject asyncIterator;

JsObject createPath(String path, List<String> sources, Object options) {
  return _createPath(path, sources, jsify(options));
}

// Taken from https://stackoverflow.com/questions/65754406/how-to-map-a-javascript-function-returning-an-async-iterator-in-dart-using-packa
Stream<T> _asyncIterator<T>(jsIterator) async* {
  while (true) {
    final next = await promiseToFuture(callMethod(jsIterator, 'next', []));
    if (getProperty(next, 'done')) {
      break;
    }
    yield getProperty(next, 'value');
  }
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

  LDflexEntity call(String method, List<Object?> args) {
    return LDflexEntity.fromPath(callMethod(_path, method, args));
  }

  Future<LDflexEntity> resolve() async {
    Iterable<LDflexEntity> entities = await awaitIterator();
    return entities.elementAt(0);
  }

  Future<Iterable<LDflexEntity>> awaitIterator() async {
    List<dynamic> entities =
        await promiseToFuture(callMethod(_path, 'toArray', []));
    return entities.map((path) => LDflexEntity.fromPath(path));
  }

  // We need to add this
  // asyncIterator: new _AsyncIteratorHandler__WEBPACK_IMPORTED_MODULE_1__["default"](),
  Stream<LDflexEntity> stream() async* {
    // dynamic iterator = await promiseToFuture(getProperty(_path, 'asyncIterator'));
    // dynamic iterator = await promiseToFuture(callMethod(_path, 'asyncIterator', []));
    dynamic iterator = callMethod(_path, 'asyncIterator', []);
    while (true) {
      final next = await promiseToFuture(callMethod(iterator, 'next', []));
      if (getProperty(next, 'done')) {
        break;
      }
      yield LDflexEntity.fromPath(getProperty(next, 'value'));
    }
  }

  String toString() {
    return callMethod(_path, 'toString', []);
  }

  // Future<String> toResolveString() async {
  //   return (await resolve()).toString();
  // }
  // TODO: Move this to a flutter specific extended class
  FutureBuilder<LDflexEntity> toTextWidget() {
    return FutureBuilder<LDflexEntity>(
      future: resolve(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data?.toString() ?? '');
        }
        return Container();
      },
    );
  }
}

class LDflexWidget extends StatelessWidget {
  late LDflexEntity _entity;
  LDflexWidget(String path, List<String> sources, Object options, {Key? key})
      : super(key: key) {
    _entity = LDflexEntity(path, sources, options);
  }
  // LDflexEntity entity;
  // LDflexWidget(String path, List<String> sources, Object options, {Key? key}) : super(key: key) {
  //   entity = LDflexEntity(path, sources, options);
  // }
  LDflexWidget.fromEntity(LDflexEntity entity, {Key? key}) : super(key: key) {
    _entity = entity;
  }
  LDflexWidget operator [](String index) {
    return LDflexWidget.fromEntity(_entity[index]);
  }

  LDflexWidget call(String method, List<Object?> args) {
    return LDflexWidget.fromEntity(_entity.call(method, args));
  }

  Future<LDflexWidget> resolve() async {
    return LDflexWidget.fromEntity(await _entity.resolve());
  }

  @override
  Widget build(BuildContext context) {
    return _entity.toTextWidget();
  }
}

// typedef LDflexWidgetShortcut = LDflexWidget Function(String path);

LDflexWidget Function(String path) LDflexWidgetFactory(
    List<String> sources, Object options) {
  return (String path) {
    return LDflexWidget(path, sources, options);
  };
}

// TODO: Re-implement with mixins
// class LDflexWidget extends StatelessWidget {
//   late LDflexEntity _entity;
//   LDflexWidget(String path, List<String> sources, Object options, {Key? key}) : super(key: key) {
//     _entity = LDflexEntity(path, sources, options);
//   }
//   // LDflexEntity entity;
//   // LDflexWidget(String path, List<String> sources, Object options, {Key? key}) : super(key: key) {
//   //   entity = LDflexEntity(path, sources, options);
//   // }
//   LDflexWidget.fromEntity(LDflexEntity entity, {Key? key}) : super(key: key) {
//     _entity = entity;
//   }
//   LDflexWidget operator [](String index) {
//     return LDflexWidget.fromEntity(_entity[index]);
//   }
//   LDflexWidget call(String method, List<Object?> args) {
//     return LDflexWidget.fromEntity(_entity.call(method, args));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Text(_entity.toString());
//   }
// }

// class FlutterLDflexEntity extends LDflexEntity {
//   FlutterLDflexEntity(String path, List<String> sources, Object options) {
//     super(path, sources, options)
//   }
//   FutureBuilder<String> toWidget()
// }

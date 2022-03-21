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
external JsObject _createPath(String path, List<String> sources, dynamic options);

JsObject createPath(String path, List<String> sources, Object options) {
  return _createPath(path, sources, jsify(options));
}

class LDflexEntity {
  // JavaScriptObject
  dynamic _path;
  LDflexEntity(String path, List<String> sources, Object options) {
    _path = createPath(path, sources, options);
  }
  LDflexEntity.fromPath(dynamic path) {
    _path = path;
  }
  LDflexEntity operator [](String index) {
    return LDflexEntity.fromPath(getProperty(_path, index));
  }
  LDflexEntity call(String method, List<Object> args) {
    return LDflexEntity.fromPath(callMethod(_path, method, args));
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

  Future<LDflexEntity> resolve() async {
      Iterable<LDflexEntity> entities = await awaitIterator();
      return entities.isEmpty ? null : entities.elementAt(0);
  }
  Future<Iterable<LDflexEntity>> awaitIterator() async {
    List<dynamic> entities = await promiseToFuture(callMethod(_path, 'toArray', []));
    return entities.map((path) => LDflexEntity.fromPath(path));
  }
  String toString() {
    return callMethod(_path, 'toString', []);
  }
  // Future<String> toResolveString() async {
  //   return (await resolve()).toString();
  // }
  // TODO: Move this to a flutter specific extended class
  FutureBuilder<LDflexEntity> toTextWidget({
  Key key,
  TextStyle style,
  StrutStyle strutStyle,
  TextAlign textAlign,
  TextDirection textDirection,
  Locale locale,
  bool softWrap,
  TextOverflow overflow,
  double textScaleFactor,
  int maxLines,
  String semanticsLabel,
  TextWidthBasis textWidthBasis,
  TextHeightBehavior textHeightBehavior,
}) {
    return FutureBuilder<LDflexEntity>(
      future: resolve(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data?.toString() ?? '',
  key: key,
  style: style,
  strutStyle: strutStyle,
  textAlign: textAlign,
  textDirection: textDirection,
  locale: locale,
  softWrap: softWrap,
  overflow: overflow,
  textScaleFactor: textScaleFactor,
  maxLines: maxLines,
  semanticsLabel: semanticsLabel,
  textWidthBasis: textWidthBasis,
  textHeightBehavior: textHeightBehavior,
);
        }
        return Container();
      },
    );
  }
}

class LDflexWidget extends StatelessWidget {
  LDflexEntity _entity;
  LDflexWidget(String path, List<String> sources, Object options, {Key key}) : super(key: key) {
    _entity = LDflexEntity(path, sources, options);
  }
  // LDflexEntity entity;
  // LDflexWidget(String path, List<String> sources, Object options, {Key? key}) : super(key: key) {
  //   entity = LDflexEntity(path, sources, options);
  // }
  LDflexWidget.fromEntity(LDflexEntity entity, {Key key}) : super(key: key) {
    _entity = entity;
  }
  LDflexWidget operator [](String index) {
    return LDflexWidget.fromEntity(_entity[index]);
  }
  // LDflexWidget call(String method, List<Object> args) {
  //   return LDflexWidget.fromEntity(_entity.call(method, args));
  // }
  Widget call({
  Key key,
  TextStyle style,
  StrutStyle strutStyle,
  TextAlign textAlign,
  TextDirection textDirection,
  Locale locale,
  bool softWrap,
  TextOverflow overflow,
  double textScaleFactor,
  int maxLines,
  String semanticsLabel,
  TextWidthBasis textWidthBasis,
  TextHeightBehavior textHeightBehavior,
}) {
    return _entity.toTextWidget(
        key: key,
  style: style,
  strutStyle: strutStyle,
  textAlign: textAlign,
  textDirection: textDirection,
  locale: locale,
  softWrap: softWrap,
  overflow: overflow,
  textScaleFactor: textScaleFactor,
  maxLines: maxLines,
  semanticsLabel: semanticsLabel,
  textWidthBasis: textWidthBasis,
  textHeightBehavior: textHeightBehavior,
    );
  }
  @override
  Widget build(BuildContext context) {
    return _entity.toTextWidget();
  }
}

// typedef LDflexWidgetShortcut = LDflexWidget Function(String path);

LDflexWidget Function(String path) LDflexWidgetFactory(List<String> sources, Object options) {
  return (String path) {
    return LDflexWidget(path, sources, options);
  };
}

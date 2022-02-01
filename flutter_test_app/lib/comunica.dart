@JS('comunica')
library comunica;

import 'package:js/js.dart';
import 'dart:async';
import 'dart:js_util';
import 'dart:js';
// import './stringify.dart';
// import './rdf/dataset/data-model.dart';

@JS()
abstract class Promise<T> {}

@JS('ComunicaEngine')
class ComunicaEngine {
  external ComunicaEngine();
  @JS('query')
  external Promise<JsObject> query(String query, Object context);
}

abstract class IActorQueryOperationOutputBase {
  abstract String type;
}

class Term {
  String termType;
  String value;

  Term.fromJS(json)
    : termType = getProperty(json, 'termType'),
      value = getProperty(json, 'value');
}

class IActorQueryOperationOutputBindings {
  String type = 'bindings';
  Iterable<Map<String, Term>> bindings;
  List<String> variables;

  IActorQueryOperationOutputBindings.fromJS(data, List<dynamic> bindings)
    : variables = getProperty(data, 'variables')
    , bindings = bindings.map((e) {
      List<String> variables = getProperty(data, 'variables');
      return Map<String, Term>.fromIterable(variables,
        value: (binding) =>  Term.fromJS(callMethod(e, 'get', [binding])));
    });
    }

class QueryEngine {
  ComunicaEngine _engine = ComunicaEngine();
  Future<IActorQueryOperationOutputBindings> query(String query, Object context) async {
    Promise<JsObject> promise = _engine.query(query, jsify(context));
    var data = await promiseToFuture(promise);
    var bindings = await promiseToFuture(callMethod(data, 'bindings', []));

    return IActorQueryOperationOutputBindings.fromJS(
      data,
      bindings
    );
  }
}

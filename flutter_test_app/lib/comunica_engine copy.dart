@JS('comunica')
library comunica;

import 'package:js/js.dart';
import 'dart:async';
import 'dart:js_util';
import 'dart:js';
import './stringify.dart';

@JS()
abstract class Promise<T> {}

@JS('ComunicaEngine')
class ComunicaEngine {
  external ComunicaEngine();
  @JS('query')
  external Promise<JsObject> query(String query, Object context);
  // Future<Object> query(String query, Object context) {
  //   return promiseToFuture(_query(query, context));
  // }
}

abstract class IActorQueryOperationOutputBase {
  abstract String type;
}

// type 

// abstract class IActorQueryOperationOutputQuads {
//   String type = 'quads';
//   quadStream: RDF.Stream & AsyncIterator<RDF.Quad>;
// }

class IActorQueryOperationOutputBindings {
  String type = 'bindings';
  List<String> variables;

  // IActorQueryOperationOutputBindings();
  IActorQueryOperationOutputBindings.fromJson(data)
    : variables = getProperty(data, 'variables');
}

class QueryEngine {
  ComunicaEngine _engine = ComunicaEngine();
  Future<IActorQueryOperationOutputBindings> query(String query, Object context) async {
    Promise<JsObject> promise = _engine.query(query, jsify(context));
    // print(JsObject.fromBrowserObject(promise)['promise']);
    // print(stringify(promise));

    print('----');
    var data = await promiseToFuture(promise);
    print('---');
    // print(stringify(data));
    // getProperty(data, 'type')

    print(getProperty(data, 'type'));

    // JsObject d2 = JsObject.fromBrowserObject(data);

    // print('--- - ---');
    // print(d2.hasProperty('type'));
    // print('--- - ---');
    // print(data['variables']);
    return IActorQueryOperationOutputBindings.fromJson(await promiseToFuture(promise));
    // return promiseToFuture(_engine.query(query, jsify(context)));
  }
}

// class QueryEngine {
//   ComunicaEngine _engine = ComunicaEngine();
//   Future<Object> query(String query, Object context) {
//     return promiseToFuture(_engine.query(query, jsify(context)));
//   }
// }

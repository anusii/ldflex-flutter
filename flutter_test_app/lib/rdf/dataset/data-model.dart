library data_model;

import 'dart:js_util';

class Term {
  String termType;
  String value;

  Term.fromJS(json)
    : termType = getProperty(json, 'termType'),
      value = getProperty(json, 'value');
}


// class NamedNode {
//     String termType = "NamedNode";
//     String value: String;

//     /**
//      * @param other The term to compare with.
//      * @return True if and only if other has termType "NamedNode" and the same `value`.
//      */
//     equals(other: Term | null | undefined): boolean;
// }

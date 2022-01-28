# ldflex-flutter
A flutter wrapper for LDflex

WIP:

Usage for now is as follows.

1) Include `bundle.js` as a script in your index file 
```html
<script src="bundle-3.js"></script>
```

2) Add ldflex.dart as a file in your project

You can now use the `LdflexEntity` class as follows

```dart
// Context as described in https://github.com/ldflex/ldflex
Object context = {
  "@context": {
    "@vocab": "http://xmlns.com/foaf/0.1/",
    "friends": "knows",
    "label": "http://www.w3.org/2000/01/rdf-schema#label",
    "rbn": "https://ruben.verborgh.org/profile/#",
  },
};

var person = LDflexEntity(
  // URI of the entity you are interested in
  'https://ruben.verborgh.org/profile/#me',
  // URI(s) of the document(s) you want to query over
  ['https://ruben.verborgh.org/profile/'],
  { "context": context }
);

// To get the label of their interest, access as if accessing a local graph and then use `.resolve` to resolve the data before using it
var label = await person['interest']['label'].resolve()
// or var label = await person['http://xmlns.com/foaf/0.1/interest']['http://www.w3.org/2000/01/rdf-schema#label'].resolve()

print("This person is interested in: ")
print(label)
```

Most of the functionality available at https://github.com/ldflex/ldflex should be available here, noting the following key things:

For function calls, one needs to use the patterns:

To return iterables rather than single results one needs to use `.resolveIterator`

```dart
var labels = await person['interest']['label'].resolveIterator()
```

To call functions one needs to use `.call`

```dart
var uris = await person['interest'].call('sort', 'label').resolveIterator()
```

You *cannot* use dot `.` properties, everything must be accessed via the `[]` operator. i.e. one must use `person['interest']['label']` rather than `person.interest.label`

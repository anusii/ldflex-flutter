# ldflex-flutter
A flutter wrapper for LDflex

WIP:

Usage for now is as follows.

1) Include `bundle.js` as a script in your index file 
```html
<script src="bundle.js"></script>
```

2) Add ldflex.dart as a file in your project

This package exports two key classes `LDflexWidget` and `LDflexEntity`. For most development applications you will want to use the `LDflexWidget` class. 

## Using `LDflexWidget`

`LDflexWidget`s are like an ldflex entity object, but also contain a `build` method which resolves the path and creates a `FutureBuild` widget. This allows us to do the following

```dart
// Set up link to document and context
// This is usually an application-wide configuration
var rubenProfile = LDflexWidgetFactory([
    'https://ruben.verborgh.org/profile/'
  ], {
    "context": {
      "@context": {
        "@vocab": "http://xmlns.com/foaf/0.1/",
        "friends": "knows",
        "label": "http://www.w3.org/2000/01/rdf-schema#label",
        "rbn": "https://ruben.verborgh.org/profile/#",
      },
    }
  });

// Create entity we are interested in within the document
LDflexWidget ruben = rubenProfile('https://ruben.verborgh.org/profile/#me')

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ruben['label'],
            const Text(' is interested in '),
            ruben['interest']['label']
          ],
        ),
      ),
    );
  }
}
```

## Using `LdflexEntity`

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

To return iterables rather than single results one needs to use `.resolveIterator`

```dart
var labels = await person['interest']['label'].resolveIterator()
```

To call functions one needs to use `.call`, the first argument is the function name, the second argument is a list of args for the function you want to call

```dart
var uris = await person['interest'].call('sort', ['label']).resolveIterator()
```

You *cannot* use dot `.` properties, everything must be accessed via the `[]` operator. i.e. one must use `person['interest']['label']` rather than `person.interest.label`

## Running the test app

To run the test application run `flutter run` - the result should look like:

![https://github.com/anusii/comunica-flutter/blob/main//test_app.png](https://github.com/anusii/comunica-flutter/blob/main//test_app.png)

If you have CORS errors follow the instructions [here](https://www.google.com/search?channel=fs&client=ubuntu&q=chrome+disable+cors).

# osm_overpass

A dio compatible dart package to query the OpenStreetMap Overpass API. 

## Getting started

To get started add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  osm_overpass: ^0.0.2
```

Then you can import the package in your Dart code:

```dart
import 'package:osm_overpass/osm_overpass.dart';
```

## Usage

To query the OpenStreetMap Overpass API you can use the `Overpass` class. The `query` method takes a `script` parameter which is the Overpass QL script to run and a `bbox` parameter which is the bounding box to query within. The `query` method returns a list of `Element` objects which represent the results of the query.

```dart
import 'package:osm_overpass/osm_overpass.dart';

void main() async {
  final overpass = Overpass();
  final elements = await overpass.query(
    script: 'node[amenity=bar]({{bbox}});\nout;', 
    bbox: (-27.460467537569297,153.03190097931952,-27.454260316536676,153.03804860238165)
  );
  
  for (final element in elements!) {
    print(element.toMap());
  }
}
```

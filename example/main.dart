import 'package:osm_overpass/osm_overpass.dart';

void main() async {
  final overpass = Overpass();
  final elements = await overpass.query(
      script: OverpassScripts.military,
      bbox: (
        -27.448973694303366,
        152.9391777646606,
        -27.412639850147155,
        153.0001047966666
      ));

  for (final element in elements!) {
    print(element.toMap());
  }
}

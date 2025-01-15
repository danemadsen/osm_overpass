import 'package:osm_overpass/osm_overpass.dart';

void main() async {
  final overpass = Overpass();
  final elements = await overpass.query(scriptText: 'node[amenity=bar]({{bbox}});\nout;', bbox: (-27.460467537569297,153.03190097931952,-27.454260316536676,153.03804860238165));
  print(elements);
}
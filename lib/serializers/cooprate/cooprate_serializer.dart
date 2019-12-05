import 'package:kite_bird/kite_bird.dart';

class CoopratesSerializer extends Serializable {
  String name;

  @override
  Map<String, dynamic> asMap() {
    return {
      'name': name,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    name = object['name'].toString();
  }

}
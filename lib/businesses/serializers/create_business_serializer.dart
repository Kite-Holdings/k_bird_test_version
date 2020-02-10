import 'package:kite_bird/kite_bird.dart';

class CreateBusinessSerializer extends Serializable{
  String name;
  String uid;
  // String state;
  @override
  Map<String, dynamic> asMap() => {
    'name': name,
    'uid': uid,
    // 'state': state
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    name = object['name'].toString();
    uid = object['uid'].toString();
    // state = object['state'].toString();
  }

}
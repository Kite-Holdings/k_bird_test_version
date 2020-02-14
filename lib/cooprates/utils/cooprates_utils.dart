import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateModel;

Future<String> getCooprateCodeById(String id) async{
  final CooprateModel _cooprateModel = CooprateModel();
  final Map<String, dynamic> _dbRes = await _cooprateModel.findById(id, fields: ['code']);

  if(_dbRes['status'] == 0){
    return _dbRes['body']['code'].toString();
  } else{
    return null;
  }
}
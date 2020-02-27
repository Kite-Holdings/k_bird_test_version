import 'package:kite_bird/cooprates/models/cooprates_models.dart' show
        CooprateMpesaCbModel, CooprateMpesaBcModel, where,
        CooprateBankModel,
        CooprateCardModel;

class CooprateAccountConfModule{
  CooprateAccountConfModule({this.cooprateCode});

  final String cooprateCode;


  Future<CooprateMpesaCbModel> mpesaCbConf()async{
    final CooprateMpesaCbModel _cooprateMpesaModel = CooprateMpesaCbModel();
    final Map<String, dynamic> _dbRes = await _cooprateMpesaModel.findOneBy(where.eq('cooprateCode', cooprateCode));
    if(_dbRes['status'] == 0){
      return _cooprateMpesaModel.fromMap(_dbRes['body']);
    } else {
      return CooprateMpesaCbModel();
    }
  }
  Future<CooprateMpesaBcModel> mpesaBcConf()async{
    final CooprateMpesaBcModel _cooprateMpesaModel = CooprateMpesaBcModel();
    final Map<String, dynamic> _dbRes = await _cooprateMpesaModel.findOneBy(where.eq('cooprateCode', cooprateCode));
    if(_dbRes['status'] == 0){
      try{
        return _cooprateMpesaModel.fromMap(_dbRes['body']);
      } catch (e){
        return CooprateMpesaBcModel();
      }
    } else {
      return CooprateMpesaBcModel();
    }
  }
  
  
  Future<CooprateBankModel> bankConf()async{
    final CooprateBankModel _cooprateBankModel = CooprateBankModel();
    final Map<String, dynamic> _dbRes = await _cooprateBankModel.findOneBy(where.eq('cooprateCode', cooprateCode));
    if(_dbRes['status'] == 0){
      return _cooprateBankModel.fromMap(_dbRes['body']);
    } else {
      return CooprateBankModel();
    }
  }

  Future<CooprateCardModel> cardConf()async{
    final CooprateCardModel _cooprateCardModel = CooprateCardModel();
    final Map<String, dynamic> _dbRes = await _cooprateCardModel.findOneBy(where.eq('cooprateCode', cooprateCode));
    if(_dbRes['status'] == 0){
      return _cooprateCardModel.fromMap(_dbRes['body']);
    } else {
      return CooprateCardModel();
    }
  }
  
  
}


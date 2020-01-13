import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';

class MerchantAccountSerializer extends Serializable{
  String username;
  String companyName;
  String cooprateCode;
  String phoneNo;
  @override
  Map<String, dynamic> asMap()=>{
    'username': username,
    'companyName': companyName,
    'cooprateCode': cooprateCode,
    'phoneNo': phoneNo,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    username = object['username'].toString();
    companyName = object['companyName'].toString();
    cooprateCode = object['cooprateCode'].toString();
    phoneNo = object['phoneNo'].toString();
  }
  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    final CooprateModel _cooprateModel = CooprateModel();
    final String _phoneNo = object['phoneNo'].toString();
    final RegExp _allAreNumbers = RegExp(r'(^[0-9]{12}$)');
    final RegExp _startsWith = RegExp(r'(^2547)');
    Iterable<String> _reject;
    if(_allAreNumbers.hasMatch(_phoneNo) && _startsWith.hasMatch(_phoneNo)){
      _reject = reject;
      // check if cooprate code exist
      _cooprateModel.exists(where.eq('code', object['cooprateCode'].toString())).then((bool codeExist){
        if(codeExist){
          _reject = _reject;
        } else{
          _reject=['cooprateCode'];
        }
      });

    } else{
      _reject = ['phoneNo'];
    }
    // check if cooprate code exist
    _cooprateModel.exists(where.eq('code', object['cooprateCode'].toString())).then((bool codeExist){
      if(codeExist){
        _reject = _reject;
      } else{
        _reject=['cooprateCode'];
      }
    });

    super.read(object, ignore: ignore, reject: _reject, require: require);
  }


}
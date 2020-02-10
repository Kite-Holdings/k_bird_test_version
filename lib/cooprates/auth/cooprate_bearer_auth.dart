import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/token/models/token_model.dart';

class CooprateBearerAouthVerifier extends AuthValidator{
  TokenModel tokenModel = TokenModel();
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final String _token = authorizationData.toString();
    final Map<String, dynamic> _tokenMap = await tokenModel.findBySelector(where.eq("token", _token));
    
    final int seconds = (DateTime.now().millisecondsSinceEpoch/1000).floor();
    if(_tokenMap['status'] != 0){
      return null;
    } else{
      final _tokenInfo =  _tokenMap['body'].length !=0 ? _tokenMap['body'].first : null;
      if (_tokenInfo == null) {
        return null;
      }

      if (seconds >= int.parse(_tokenInfo['validTill'].toString())) {
        return null;
      } else {
        if(_tokenInfo['collection'].toString() == cooprateCollection){
          return Authorization(_tokenInfo['ownerId'].toString(), 0, this, );
        } else {
          return null;
        }
      }
    }
  }
}

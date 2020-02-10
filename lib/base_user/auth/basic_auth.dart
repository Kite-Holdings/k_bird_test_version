import 'package:kite_bird/base_user/models/base_user_models.dart';
import 'package:kite_bird/base_user/requests/requests_manager.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class BaseUserBasicAouthVerifier extends AuthValidator {

  final UserModel userModel = UserModel();
  String _requestId;
  final ResposeType _responseType = ResposeType.token;
  ResponsesStatus _responseStatus;
  // dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    Authorization _authorization;
    bool _saveRequestResponse = true;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final Map<String, dynamic> _accounts = await userModel.findBySelector(where.eq("email", _aouthDetails[0]));
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _aouthDetails[0],
      baseUserRequestsType: BaseUserRequestsType.login,
      metadata: _aouthDetails
    );
    _requestId = _baseUserRequests.requestId();

    if(_accounts['status'] != 0){
      _responseBody = {"status": 1, "body": "internal error"};
      _responseStatus = ResponsesStatus.error;
      _authorization = null;
    } else {
      final _account = _accounts['body'].length !=0 ? _accounts['body'].first : null;

      if(_account == null) {
        _responseBody = {"status": 1, "body": "wrong Email"};
        _responseStatus = ResponsesStatus.failed;        
        _authorization = null;

      } 
      else if (userModel.verifyPassword(_aouthDetails[1], _account['password'].toString())) {
        final String _id = _account['_id'].toString().split('\"')[1];
        _authorization = Authorization(_id, 0, this, );
        _saveRequestResponse = false;
      }
      else {
        _responseBody = {"status": 1, "body": "wrong Password"};
        _responseStatus = ResponsesStatus.failed;
        _authorization = null;
      }

    }
    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );
    if(_saveRequestResponse){
      await _responsesModel.save();
      _baseUserRequests.normalRequest();
    }

    return _authorization;
  }
    
  
}

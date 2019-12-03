import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/requests_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/user_models.dart';

class CooprateBasicAouthVerifier extends AuthValidator {
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final CooprateModel cooprateModel = CooprateModel();
    final Map<String, dynamic> _companies = await cooprateModel.findBySelector(where.eq('consumerKey', _aouthDetails[0]));
    
    if(_companies['status'] != 0){
      return null;
    } else {
      final _company = _companies['body'].first;
      String _id;
      if(_company == null) {
        final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/cooprate/token',
          requestType: RequestType.token,
          account: _aouthDetails[0],
          metadata: {
            'clientId': _id,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {"message": "Wrong Consumer Key"},
          status: ResponsesStatus.failed
        );
        unawaited(_responsesModel.save());
        return Authorization(null, 0, null);
        }

      if (_company['secretKey'].toString() == _aouthDetails[1].toString()) {
        _id = _company['_id'].toString().split('\"')[1];
        return Authorization(_id, 0, this, );

      } else {
        _id = _company['_id'].toString().split('\"')[1];
        final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/cooprate/token',
          requestType: RequestType.token,
          account: _aouthDetails[0],
          metadata: {
            'clientId': _id,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {"message": "Wrong Consumer Secret"},
          status: ResponsesStatus.failed
        );
        unawaited(_responsesModel.save());
        return Authorization(null, 0, null);
      }
    }
}
}

class BaseUserBasicAouthVerifier extends AuthValidator {

  final UserModel userModel = UserModel();

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final Map<String, dynamic> _accounts = await userModel.findBySelector(where.eq("email", _aouthDetails[0]));
    if(_accounts['status'] != 0){
      return null;
    } else {
      final _account = _accounts['body'].first;
      String _id;


      if(_account == null) {

        final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/users/login',
          requestType: RequestType.token,
          account: _aouthDetails[0],
          metadata: {
            'clientId': _id,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {"message": "Wrong Email"},
          status: ResponsesStatus.failed
        );
        unawaited(_responsesModel.save());
        
        return Authorization(null, 0, null);

      } 
      else if (userModel.verifyPassword(_aouthDetails[1], _account['password'].toString())) {
        _id = _account['_id'].toString().split('\"')[1];
        return Authorization(_id, 0, this, );
      }
      else {
        _id = _account['_id'].toString().split('\"')[1];
        final ObjectId _requestId = ObjectId();
        final RequestsModel _requestsModel = RequestsModel(
          id: _requestId,
          url: '/users/login',
          requestType: RequestType.token,
          account: _aouthDetails[0],
          metadata: {
            'clientId': _id,
            'entity': 'user'
          }
        );

        unawaited(_requestsModel.save());

        final ResponsesModel _responsesModel = ResponsesModel(
          requestId: _requestId.toJson(),
          responseType: ResposeType.token,
          responseBody: {"message": "Password"},
          status: ResponsesStatus.failed
        );
        unawaited(_responsesModel.save());
        
        return Authorization(null, 0, null);
      }

    }
  }
    
  
}

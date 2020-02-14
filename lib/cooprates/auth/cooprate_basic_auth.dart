import 'package:kite_bird/cooprates/models/cooprates_models.dart';
import 'package:kite_bird/cooprates/requests/cooperate_request.dart' show CooperateRequest, CooperateRequestsType;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateBasicAouthVerifier extends AuthValidator {
  String _requestId;
  final ResposeType _responseType = ResposeType.token;
  ResponsesStatus _responseStatus;
  // dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final CooprateModel cooprateModel = CooprateModel();
    bool _saveRequestResponse = true;
    final Map<String, dynamic> _companies = await cooprateModel.findBySelector(where.eq('consumerKey', _aouthDetails[0]));
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _aouthDetails[0],
      cooperateRequestsType: CooperateRequestsType.token,
      metadata: _aouthDetails
    );
    
    _requestId = _cooperateRequest.requestId();
    
    if(_companies['status'] != 0){
      _responseBody = {"status": 1, "body": "internal error"};
      _responseStatus = ResponsesStatus.error;
      _authorization = null;
    } else {
      try{
        final _company = _companies['body'].first;
        String _id;
        if(_company == null) {
          _responseBody =  {"message": "Wrong Consumer Key"};
          _responseStatus = ResponsesStatus.failed;
          _authorization = null;
          }

        if (_company['secretKey'].toString() == _aouthDetails[1].toString()) {
          _id = _company['_id'].toString().split('\"')[1];
          _authorization = Authorization(_id, 0, this, );
          _saveRequestResponse = false;

        } else {
          _id = _company['_id'].toString().split('\"')[1];
          _responseBody =  {"message": "Wrong Secret Key"};
          _responseStatus = ResponsesStatus.failed;
          _authorization = null;
        }
      } catch (e){
        _responseBody =  {"message": "Wrong Credentilas Key"};
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
    await _responsesModel.save();if(_saveRequestResponse){
      await _responsesModel.save();
      _cooperateRequest.normalRequest();
    }
    return _authorization;
  }
}
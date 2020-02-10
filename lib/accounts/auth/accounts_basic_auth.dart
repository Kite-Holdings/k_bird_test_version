import 'package:kite_bird/accounts/models/accounts_models.dart' show RegisterAccountVerificationModel, AccountModel, where;
import 'package:kite_bird/accounts/request_manager/account_request.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class AccountVerifyOtpAouthVerifier extends AuthValidator {
  final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  bool _saveRequestResponse = true;
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async{
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final int _nowMili = (DateTime.now().millisecondsSinceEpoch/1000).floor();
    int _otp;
    try {
      _otp = int.parse(_aouthDetails[1]);
    } catch (e) {
      _responseBody = {'body': 'invalid otp'};
    }
    final Map<String, dynamic> _dbRes = await _registerAccountVerificationModel.findBySelector(
      where.eq('phoneNo', _aouthDetails[0])
        .eq('otp', _otp)
        .gte('expireTime', _nowMili)
        );
    
    // save request
    final AccountRequest _accountRequest = AccountRequest(
      account: _aouthDetails[0],
      accountRequestsType: AccountRequestsType.registerConsumer,
      metadata: _aouthDetails
    );
    
    _requestId = _accountRequest.requestId();
    
    if(_dbRes['status'] != 0){
      _responseBody = {"status": 1, "body": "internal error"};
      _responseStatus = ResponsesStatus.error;
      _authorization = null;
    }else{
      final item = _dbRes['body'].length !=0 ? _dbRes['body'].first : null;
      if(item == null){
        _responseBody = {"status": 1, "body": "wrong credentials"};
        _responseStatus = ResponsesStatus.failed;
        _authorization = null;
      }else{
        _authorization = Authorization(item['_id'].toString().split('\"')[1], 0, null);
        _saveRequestResponse = false;
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
      _accountRequest.normalRequest();
    }
    
    return _authorization;
  }
  
}


class AccountLoginAouthVerifier extends AuthValidator {
  final AccountModel _accountModel = AccountModel();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  bool _saveRequestResponse = true;
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final Map<String, dynamic> _dbRes = await _accountModel.findBySelector(where.eq('phoneNo', _aouthDetails[0]));

    // save request
    final AccountRequest _accountRequest = AccountRequest(
      account: _aouthDetails[0],
      accountRequestsType: AccountRequestsType.login,
      metadata: _aouthDetails
    );
    
    _requestId = _accountRequest.requestId();

    if(_dbRes['status'] != 0){
      _responseBody = {"status": 1, "body": "internal error"};
      _responseStatus = ResponsesStatus.error;
      _authorization = null;
    }else{
      final item = _dbRes['body'].length !=0 ? _dbRes['body'].first : null;
      if(item == null){
        _responseBody = {"status": 1, "body": "user does not exist"};
        _responseStatus = ResponsesStatus.failed;
        _authorization = null;
      }else{
        if(_accountModel.verifyPassword(_aouthDetails[1], item['password'].toString())){
          _authorization = Authorization(item['_id'].toString().split('\"')[1], 0, null);
          _saveRequestResponse = false;
        } else {
          _responseBody = {"status": 1, "body": "wrong credentials"};
          _responseStatus = ResponsesStatus.failed;
          
        }
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
      _accountRequest.normalRequest();
    }

    return _authorization;
  }
}
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/account_model.dart';
import 'package:kite_bird/models/accounts/register_account_verification_model.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/user_models.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:kite_bird/requests_managers/base_user_resquests.dart';
import 'package:kite_bird/requests_managers/cooperate_request.dart';
import 'package:pedantic/pedantic.dart';

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
    final Map<String, dynamic> _companies = await cooprateModel.findBySelector(where.eq('consumerKey', _aouthDetails[0]));
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: _aouthDetails[0],
      cooperateRequestsType: CooperateRequestsType.token,
      metadata: _aouthDetails
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();
    
    if(_companies['status'] != 0){
      _responseBody = {"status": 1, "body": "internal error"};
      _responseStatus = ResponsesStatus.error;
      _authorization = null;
    } else {
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

      } else {
        _id = _company['_id'].toString().split('\"')[1];
        _responseBody =  {"message": "Wrong Secret Key"};
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
    unawaited(_responsesModel.save());

    return _authorization;
  }
}

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
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final Map<String, dynamic> _accounts = await userModel.findBySelector(where.eq("email", _aouthDetails[0]));
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _aouthDetails[0],
      baseUserRequestsType: BaseUserRequestsType.login,
      metadata: _aouthDetails
    );
    _baseUserRequests.normalRequest();
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
    unawaited(_responsesModel.save());

    return _authorization;
  }
    
  
}

class AccountVerifyOtpAouthVerifier extends AuthValidator {
  final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async{
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final int _nowMili = (DateTime.now().millisecondsSinceEpoch/1000).floor();
    final Map<String, dynamic> _dbRes = await _registerAccountVerificationModel.findBySelector(
      where.eq('phoneNo', _aouthDetails[0])
        .eq('otp', int.parse(_aouthDetails[1]))
        .gte('expireTime', _nowMili)
        );
    
    // save request
    final AccountRequest _accountRequest = AccountRequest(
      account: _aouthDetails[0],
      accountRequestsType: AccountRequestsType.verifyOtp,
      metadata: _aouthDetails
    );
    _accountRequest.normalRequest();
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
      }
    }

    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );
    unawaited(_responsesModel.save());
    
    return _authorization;
  }
  
}


class AccountLoginAouthVerifier extends AuthValidator {
  final AccountModel _accountModel = AccountModel();
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");
    final Map<String, dynamic> _dbRes = await _accountModel.findBySelector(where.eq('phoneNo', _aouthDetails[0]));

    // save request
    final AccountRequest _accountRequest = AccountRequest(
      account: _aouthDetails[0],
      accountRequestsType: AccountRequestsType.verifyOtp,
      metadata: _aouthDetails
    );
    _accountRequest.normalRequest();
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
    unawaited(_responsesModel.save());



    return _authorization;
  }
}
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/account_model.dart';
import 'package:kite_bird/models/accounts/register_account_verification_model.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:kite_bird/serializers/accounts/account_serializer.dart';
import 'package:pedantic/pedantic.dart';

class RegisterConsumerAccount extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.post()
  Future<Response> create(@Bind.body(require: ['username', 'password']) AccountSerializer accountSerializer)async{
    // Save Request
    print(",,,,");
    final AccountRequest _accountRequest = AccountRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      accountRequestsType: AccountRequestsType.registerConsumer,
      metadata: accountSerializer.asMap()
    );
    _accountRequest.normalRequest();
    _requestId = _accountRequest.requestId();

    // get phoneNo
    final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel();
    final Map<String, dynamic> _dbRes = await _registerAccountVerificationModel.findById(request.authorization.clientID);
    final CooprateModel _cooprateModel = CooprateModel();
    final Map<String, dynamic> _cooprateMap =await _cooprateModel.findById(_dbRes['body']['cooprateId'].toString()); 

    print(_cooprateMap);

    if(_dbRes['status'] != 0){
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured"};
    } else{
      final String _phoneNo = _dbRes['body']['phoneNo'].toString();

      // save account
      final AccountModel _accountModel = AccountModel(
        accountType: AccountType.consumer,
        cooprateCode: _cooprateMap['body']['code'].toString(),
        password: accountSerializer.passord,
        phoneNo: _phoneNo,
        username: accountSerializer.username
      );
      final Map<String, dynamic> _res = await _accountModel.save();

      if(_res['status'] != 0){
        if(_res['body']['code'] == 11000){
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {"body": "account exist"};
        }else{
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "an error occured"};
        }
      } else{
        // create wallet
        await _accountModel.createWallet();
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "Account saved"};
      }
    }

    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();


  }
}
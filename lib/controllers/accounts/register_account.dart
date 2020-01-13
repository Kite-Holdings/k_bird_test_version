import 'dart:convert';

import 'package:kite_bird/configs/jarvis/jarvis_sms_config.dart';
import 'package:kite_bird/controllers/accounts/create_merchant_wallet.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/account_model.dart';
import 'package:kite_bird/models/accounts/register_account_verification_model.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:kite_bird/serializers/accounts/account_serializer.dart';
import 'package:kite_bird/serializers/accounts/merchant_account_serializer.dart';
import 'package:kite_bird/utils/random_alphernumeric.dart';
import 'package:http/http.dart' as http;

class RegisterConsumerAccount extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.post()
  Future<Response> create(@Bind.body(require: ['username', 'password']) AccountSerializer accountSerializer)async{
    // Save Request
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


    if(_dbRes['status'] != 0){
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured"};
    } else{
      final String _phoneNo = _dbRes['body']['phoneNo'].toString();

      // save account
      final AccountModel _accountModel = AccountModel(
        accountType: AccountType.consumer,
        cooprateCode: _cooprateMap['body']['code'].toString(),
        password: accountSerializer.password,
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
    await _responsesModel.save();
    return _responsesModel.sendResponse();

  }
}

class RegisterMerchantAccount extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.post()
  Future<Response> create(@Bind.body(require: ['username', 'companyName', 'cooprateCode', 'phoneNo']) MerchantAccountSerializer merchantAccountSerializer)async{
    // Save Request
    final AccountRequest _accountRequest = AccountRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      accountRequestsType: AccountRequestsType.registerMerchant,
      metadata: merchantAccountSerializer.asMap()
    );
    _accountRequest.normalRequest();
    _requestId = _accountRequest.requestId();

    // Generate password
    final String password = randomString(8);

    // check if cooprate exist
    final CooprateModel _cooprateModel = CooprateModel();
    final bool _cooprateExist = await _cooprateModel.exists(where.eq('code', merchantAccountSerializer.cooprateCode));
    if(!_cooprateExist){
      _responseStatus = ResponsesStatus.warning;
      _responseBody = {'body': 'CooprateCode Does not exist!'};
    } else{

      // save account
      final AccountModel _accountModel = AccountModel(
        accountType: AccountType.merchant,
        cooprateCode: merchantAccountSerializer.cooprateCode,
        password: password,
        phoneNo: merchantAccountSerializer.phoneNo,
        username: merchantAccountSerializer.username
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

        // create merchant wallet
        final Map<String, dynamic> _creatMerchantRes = await createMerchantController(
          accountId: _accountModel.id.toJson(),
          companyName: merchantAccountSerializer.companyName,
        );

        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "Account saved"};
        if(_creatMerchantRes['success'] != true){
          _responseStatus = ResponsesStatus.error;
          _responseBody = {"body": "an error occured!"};
        }{
          // send merchant message with details
          final String shortCode = _creatMerchantRes['shortCode'].toString();

          final _base64E = base64Encode(utf8.encode('$consumerKey:$consumeSecret'));
          final String basicAuth = 'Basic $_base64E';

          final Map<String, dynamic> _smsPayload = {
            'phoneNo': merchantAccountSerializer.phoneNo,
            'message': "Account created under KITE HOLDINGS LIMITED.\ncompanyName:\t${merchantAccountSerializer.companyName}, \nshortCode:\t$shortCode, \nusername:\t${merchantAccountSerializer.username}, \npassword:\t$password, \nEnsure you change your password on first login."
          };
          try {
            await http.post(jarvisSmsUrl, body: json.encode(_smsPayload), headers: <String, String>{'authorization': basicAuth, 'content-type': 'application/json'});
          } catch (e) {
            print(e);
          }
        }
      }
    }

   

    

    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    await _responsesModel.save();
    return _responsesModel.sendResponse();


  }
}

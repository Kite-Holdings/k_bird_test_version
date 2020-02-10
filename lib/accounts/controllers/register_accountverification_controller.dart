import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:kite_bird/accounts/models/accounts_models.dart' show RegisterAccountVerificationModel;
import 'package:kite_bird/accounts/request_manager/accounts_request_manager.dart';
import 'package:kite_bird/accounts/serializers/accounts_serializers.dart' show PhoneNoVerificationSerializer;
import 'package:kite_bird/jarvis/modules/jarvis_modules.dart' show jarvisSendSms;
// import 'package:kite_bird/configs/twilio/twilio_config.dart';

import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class RegisterAccountVerificationController extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.account;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  
  @Operation.post()
  Future<Response> confirmPhoneNo(@Bind.body(require: ['phoneNo']) PhoneNoVerificationSerializer phoneNoVerificationSerializer)async{
    // Save Request
    final AccountRequest _accountRequest = AccountRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      accountRequestsType: AccountRequestsType.verifyPhoneNo,
      metadata: {
        "phoneNo": phoneNoVerificationSerializer.phoneNo
      }
    );
    _accountRequest.normalRequest();
    _requestId = _accountRequest.requestId();


    final Random rng = Random();
    final int _otp = 1000 + rng.nextInt(1000);
    final List<String> _splited = phoneNoVerificationSerializer.phoneNo.split('7');
    String _phoneNo;
    final StringBuffer _stringBuffer = StringBuffer();
    _stringBuffer.write('254');
    for(int i = 1; i < _splited.length; i++){
      _stringBuffer.write('${'7'}${_splited[i]}');
    }
    _phoneNo = _stringBuffer.toString();

    // Save details
    final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel(
      phoneNo: _phoneNo, 
      otp: _otp,
      cooprateId: request.authorization.clientID
      );
    await _registerAccountVerificationModel.save();

    // send otp
    final http.Response _otpRes = await sendOtp('$_phoneNo', _otp.toString());
    if(_otpRes.statusCode != 200){
    // if(_otpRes.statusCode != 201){ // twilio
      print(_otpRes.body);
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occoured"};
    } else{
      _responseStatus = ResponsesStatus.success;
      _responseBody = {"body": "Successful. Please wait for otp"};
    }


    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
  }

  Future<http.Response> sendOtp(String to, String otp)async{
    final http.Response _res =await jarvisSendSms(
      phoneNo: to,
      body: "To verify your Kite Wallet account enter the code: $otp"
    );
    return _res;
  
  }
}

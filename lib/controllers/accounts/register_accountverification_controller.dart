import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:kite_bird/configs/twilio/twilio_config.dart';

import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/accounts/register_account_verification_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/requests_managers/account_request.dart';
import 'package:kite_bird/serializers/accounts/phoneno_verification_serializer.dart';
import 'package:pedantic/pedantic.dart';

class RegisterAccountVerificationController extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
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
    _stringBuffer.write('+254');
    for(int i = 1; i < _splited.length; i++){
      _stringBuffer.write('${'7'}${_splited[i]}');
    }
    _phoneNo = _stringBuffer.toString();

    // Save details
    final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel(phoneNo: _phoneNo, otp: _otp);
    unawaited(_registerAccountVerificationModel.save());

    // send otp
    final http.Response _otpRes = await sendOtp(_phoneNo, _otp.toString());
    if(_otpRes.statusCode != 201){
      _responseStatus = ResponsesStatus.failed;
      _responseBody = {"status": 1, "body": _otpRes.body};
    } else{
      _responseStatus = ResponsesStatus.success;
      _responseBody = {"status": 1, "body": "Successful. Please wait for otp"};
    }


    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    unawaited(_responsesModel.save());
    return _responsesModel.sendResponse();
  }

  Future<http.Response> sendOtp(String to, String otp)async{
    const String username = consumerKeyTwilio;
    const String password = consumerSecretTwilio;
    final _base64E = base64Encode(utf8.encode('$username:$password'));
    final String basicAuth = 'Basic $_base64E';

    const String _url = 'https://api.twilio.com/2010-04-01/Accounts/ACa3fbb50b61226dd8156f52175a8759de/Messages.json';
    final Map<String, String> _body = {
      "Body": "To verify your Kite Wallet account enter the code: $otp",
      "From": "+14097684064",
      "To": to,
    };


    final http.Response _res =await http.post(_url, body: _body, headers: <String, String>{'authorization': basicAuth});
    return _res;
  
  }
}

class VerifyOtp extends ResourceController{
  // String _requestId;
  // final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  // dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.post()
  Future<Response> verify()async{
    final RegisterAccountVerificationModel _registerAccountVerificationModel = RegisterAccountVerificationModel();
    final int _nowMili = (DateTime.now().millisecondsSinceEpoch/1000).floor();
    final Map<String, dynamic> _dbRes = await _registerAccountVerificationModel.findBySelector(where.eq('phoneNo', '+254797162465').eq('otp', 1212).gte('expireTime', _nowMili));

    _responseStatus = ResponsesStatus.success;
    _responseBody = {"body": "success"};
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus);
    return _responsesModel.sendResponse();

  }
}
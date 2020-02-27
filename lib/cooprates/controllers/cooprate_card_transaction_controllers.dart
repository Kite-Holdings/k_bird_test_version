import 'dart:convert';

import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/serializers/cooprates_serializers.dart' show CooprateFlutterwaveCardSerializer;
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart';
import 'package:kite_bird/flutterwave/modules/flutterwave_modules.dart' show FlutterWaveCardDeposit;
import 'package:kite_bird/flutterwave/requests/flutterwave_requests_manager.dart' show FlutterwaveRequests;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateCardTransactionController extends ResourceController{

  String _requestId;
  final ResposeType _responseType = ResposeType.cooperate;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  
  @Operation.post()
  Future<Response> transact(
    @Bind.body(require: ['cardNo', 'cvv', 'expiryMonth', 'expiryYear', 'amount', 'email', 'refNumber', 'callbackUrl']) 
    CooprateFlutterwaveCardSerializer cooprateFlutterwaveCardSerializer) async{
      
      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.transaction,
      metadata: cooprateFlutterwaveCardSerializer.asMap()
    );
    _cooperateRequest.normalRequest();
    // _requestId = _cooperateRequest.requestId();

    final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);

    final FlutterwaveRequests _flutterwaveRequests = FlutterwaveRequests(
      account: cooprateCode,
      metadata: {
        'amount': cooprateFlutterwaveCardSerializer.amount,
        'cardNo': cooprateFlutterwaveCardSerializer.cardNo,
        'email': cooprateFlutterwaveCardSerializer.email,
        'currency': 'KES',
        'country': 'KE',
        'refNumber': cooprateFlutterwaveCardSerializer.refNumber,
        'callbackUrl': cooprateFlutterwaveCardSerializer.callbackUrl,
        'cooperateRequestId': _cooperateRequest.requestId()
      }
    );

    _flutterwaveRequests.normalRequest();
    _requestId = _flutterwaveRequests.requestId();


      
      final FlutterWaveCardDeposit _flutterWaveCardDeposit = FlutterWaveCardDeposit(
        amount: cooprateFlutterwaveCardSerializer.amount,
        cooprateCode: cooprateCode,
        callbackUrl: cooprateFlutterwaveCardSerializer.callbackUrl,
        cardNo: cooprateFlutterwaveCardSerializer.cardNo,
        cvv: cooprateFlutterwaveCardSerializer.cvv,
        email: cooprateFlutterwaveCardSerializer.email,
        expiryMonth: cooprateFlutterwaveCardSerializer.expiryMonth,
        expiryYear: cooprateFlutterwaveCardSerializer.expiryYear,
        // walletNo: cooprateFlutterwaveCardSerializer.walletNo,
        requestId: _requestId
      );

      final Map<String, dynamic> _cardRes = await _flutterWaveCardDeposit.flutterWaveCardTransact();

      // compute response
      if(_cardRes['status'] != 0){
        _responseStatus = ResponsesStatus.error;
        _responseBody = {'body': 'An error occured!'};
      } else {
        dynamic _mpesaResponseBody;
        final int _mpesaResponseStatusCode = int.parse(_cardRes['body'].statusCode.toString());
        
        try {
          _mpesaResponseBody = json.decode(_cardRes['body'].body.toString());
          _mpesaResponseBody['requestId'] = _requestId;
        } catch (e) {
          _mpesaResponseBody = _cardRes['body'].body; 
        }
        _responseBody = {'body': _mpesaResponseBody};

        switch (_mpesaResponseStatusCode) {
          case 200:
            _responseStatus = ResponsesStatus.success;
            break;
          case 400:
            _responseStatus = ResponsesStatus.failed;
            break;
          case 500:
            _responseStatus = ResponsesStatus.warning;
            break;
          default:
          _responseStatus = ResponsesStatus.notDefined;
        }
      } 



      // Save response
    final ResponsesModel _responsesModel = ResponsesModel(responseBody: _responseBody, status: _responseStatus, requestId: _requestId, responseType: _responseType);
    await _responsesModel.save();
    return _responsesModel.sendResponse();
      
    }
 
}
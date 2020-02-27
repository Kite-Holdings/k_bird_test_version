import 'dart:convert';

import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/serializers/cooprates_serializers.dart' show CooprateMpesaCbTransactionSerializer;
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/mpesa/modules/mpesa_modules.dart' show MpesaOperations;
import 'package:kite_bird/mpesa/requests/mpesa_requests_manager.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateMpesaStkController extends ResourceController{

  String _requestId;
  final ResposeType _responseType = ResposeType.cooperate;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: ['amount', 'phoneNo', 'callBackUrl', 'refNumber', 'transactionDesc']) 
    CooprateMpesaCbTransactionSerializer cooprateMpesaCbTransactionSerializer) async{

      // Save Request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.transaction,
      metadata: cooprateMpesaCbTransactionSerializer.asMap()
    );
    _cooperateRequest.normalRequest();
    _requestId = _cooperateRequest.requestId();

    final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);

    final MpesaRequest _mpesaRequest = MpesaRequest(
      account: cooprateCode,
      mpesaRequestsType: MpesaRequestsType.stkPush,
      metadata: {
        'phoneNo': cooprateMpesaCbTransactionSerializer.phoneNo,
        'amount': cooprateMpesaCbTransactionSerializer.amount,
        'callBackUrl': cooprateMpesaCbTransactionSerializer.callBackUrl,
        'refNumber': cooprateMpesaCbTransactionSerializer.refNumber,
        'transactionDesc': cooprateMpesaCbTransactionSerializer.transactionDesc,
        'walletDeposit': false,
      }
    );
    _mpesaRequest.normalRequest();
    _requestId = _mpesaRequest.requestId();


      // final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);

      final MpesaOperations _mpesaOperations =  MpesaOperations();
      final Map<String, dynamic> _mpesaRes = await _mpesaOperations.cb(
        cooprateCode: cooprateCode,
        requestId: _requestId,
        phoneNo: cooprateMpesaCbTransactionSerializer.phoneNo,
        amount: cooprateMpesaCbTransactionSerializer.amount,
        walletNo: cooprateMpesaCbTransactionSerializer.refNumber,
        transactionDesc: cooprateMpesaCbTransactionSerializer.transactionDesc,
      );

      // compute response
      if(_mpesaRes['status'] != 0){
        _responseStatus = ResponsesStatus.error;
        _responseBody = {'body': 'An error occured!'};
      } else {
        dynamic _mpesaResponseBody;
        final int _mpesaResponseStatusCode = int.parse(_mpesaRes['body'].statusCode.toString());
        
        try {
          _mpesaResponseBody = json.decode(_mpesaRes['body'].body.toString());
          _mpesaResponseBody['requestId'] = _requestId;
        } catch (e) {
          _mpesaResponseBody = _mpesaRes['body'].body; 
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
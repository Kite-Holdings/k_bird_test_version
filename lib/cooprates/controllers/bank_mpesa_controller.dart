import 'dart:convert';

import 'package:aqueduct/aqueduct.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show BankMpesaModule;
import 'package:kite_bird/bank/requests/bank_requests_manager.dart' show BankRequest, BankRequestsType;
import 'package:kite_bird/bank/serializers/bank_serializers.dart';
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CooprateBankMpesaController extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.bankMpesa;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  
  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['phoneNo', 'amount', 'transactionCurrency', 'narration', 'refNumber']) BankMpesaSerializer _bankMpesaSerializer)async{
    // save request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.transaction,
      metadata: _bankMpesaSerializer.asMap()
    );
    _cooperateRequest.normalRequest();

    final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
    
    final BankRequest _bankRequest = BankRequest(
      account: cooprateCode,
      bankRequestsType: BankRequestsType.mpesa,
      metadata: _bankMpesaSerializer.asMap(),
    );
    _bankRequest.normalRequest();
    _requestId = _bankRequest.requestId();
    
    
    final BankMpesaModule _coopMpesa = BankMpesaModule(
      phoneNo: _bankMpesaSerializer.phoneNo,
      amount: _bankMpesaSerializer.amount,
      narration: _bankMpesaSerializer.narration,
      transactionCurrency: _bankMpesaSerializer.currency,
      requestId: _requestId,
    );
    final _response = await _coopMpesa.send;

    // compute response
      if(_response['status'] != 0){
        _responseStatus = ResponsesStatus.error;
        _responseBody = {'body': 'An error occured!'};
      } else {
        dynamic _responseponseBody;
        final int _responseponseStatusCode = int.parse(_response['body'].statusCode.toString());
        
        try {
          _responseponseBody = json.decode(_response['body'].body.toString());
          _responseponseBody['requestId'] = _requestId;
        } catch (e) {
          _responseponseBody = _response['body'].body; 
        }
        _responseBody = {'body': _responseponseBody};

        switch (_responseponseStatusCode) {
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

    // save response
    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );

    await _responsesModel.save();

    return _responsesModel.sendResponse();
  }
}
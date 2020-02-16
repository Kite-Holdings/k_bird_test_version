import 'dart:convert';

import 'package:kite_bird/bank/modules/bank_modules.dart' show BankPesalinkModule;
import 'package:kite_bird/bank/requests/bank_requests_manager.dart' show BankRequestsType, BankRequest;
import 'package:kite_bird/bank/serializers/bank_serializers.dart' show BankPesalinkSerializer;
import 'package:kite_bird/cooprates/requests/cooprates_requests_manager.dart';
import 'package:kite_bird/cooprates/utils/cooprates_utils.dart';
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/response/models/response_models.dart';

class CoopratePesaLinkSendController extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.bankPesalink;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;
  
  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['accountNumber', 'amount', 'transactionCurrency', 'narration', 'bankCode', 'refNumber']) BankPesalinkSerializer _bankPesalinkSerializer)async{
    // save request
    final CooperateRequest _cooperateRequest = CooperateRequest(
      account: request.authorization != null ? request.authorization.clientID : null,
      cooperateRequestsType: CooperateRequestsType.transaction,
      metadata: _bankPesalinkSerializer.asMap()
    );
    _cooperateRequest.normalRequest();

    final String cooprateCode = await getCooprateCodeById(request.authorization.clientID);
    
    final BankRequest _bankRequest = BankRequest(
      account: cooprateCode,
      bankRequestsType: BankRequestsType.ift,
      metadata: _bankPesalinkSerializer.asMap(),
    );
    _bankRequest.normalRequest();
    _requestId = _bankRequest.requestId();
    
    final BankPesalinkModule _pesalink = BankPesalinkModule(
      accountNumber: _bankPesalinkSerializer.accountNumber,
      amount: _bankPesalinkSerializer.amount,
      transactionCurrency: _bankPesalinkSerializer.transactionCurrency,
      narration: _bankPesalinkSerializer.narration,
      bankCode: _bankPesalinkSerializer.bankCode,
      requestId: _requestId,
    );
    final _response = await _pesalink.send;

    // compute response
      if(_response['status'] != 0){
        _responseStatus = ResponsesStatus.error;
        _responseBody = {'body': 'An error occured!'};
      } else {
        dynamic _responseponseBody;
        final int _responseponseStatusCode = int.parse(_response['statusCode'].toString());
        
        try {
          _responseponseBody = json.decode(_response['body'].toString());
          _responseponseBody['requestId'] = _requestId;
        } catch (e) {
          _responseponseBody = _response['body']; 
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
import 'dart:convert';

import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/mpesa/skt_process_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/requests_managers/mpesa_request.dart';
import 'package:kite_bird/serializers/mpesa/mpesa_cb_serializer.dart';
import 'package:kite_bird/third_party_operations/mpesa/mpesa_operation.dart';
import 'package:pedantic/pedantic.dart';

class MpesaCbRequestController extends ResourceController {
  final MpesaOperations _mpesaOperations = MpesaOperations();

  String _requestId;
  final ResposeType _responseType = ResposeType.mpesaStkPush;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  @Operation.post()
  Future<Response> stk(@Bind.body(require: ['amount', 'phoneNo', 'callBackUrl', 'referenceNumber', 'transactionDesc']) MpesaCbSerializer mpesaCbSerializer)async{
    // save request
    final MpesaRequest _mpesaRequest = MpesaRequest(
      account: null,
      mpesaRequestsType: MpesaRequestsType.stkPush,
      metadata: {
        'phoneNo': mpesaCbSerializer.phoneNo,
        'amount': mpesaCbSerializer.amount,
        'callBackUrl': mpesaCbSerializer.callBackUrl,
        'referenceNumber': mpesaCbSerializer.referenceNumber,
        'transactionDesc': mpesaCbSerializer.transactionDesc,
        'walletDeposit': true,
      }
    );
    _mpesaRequest.normalRequest();
    _requestId = _mpesaRequest.requestId();

    // send stkpush
    final Map<String, dynamic> _mpesaRes =await _mpesaOperations.cb(
      amount: mpesaCbSerializer.amount,
      callBackUrl: mpesaCbSerializer.callBackUrl,
      phoneNo: mpesaCbSerializer.phoneNo,
      referenceNumber: mpesaCbSerializer.referenceNumber,
      requestId: _requestId,
      transactionDesc: mpesaCbSerializer.transactionDesc
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
    // save response
    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );

    unawaited(_responsesModel.save());

    // Stkpush Process
    final StkProcessModel _stkProcessModel = StkProcessModel(
      requestId: _requestId, 
      processState: ProcessState.pending, 
      checkoutRequestID: _responseBody['CheckoutRequestID'].toString());

    await _stkProcessModel.save();

    return _responsesModel.sendResponse();

  }
}
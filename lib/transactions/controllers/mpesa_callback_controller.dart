import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/mpesa/models/mpesa_models.dart' show 
        MpesaResponsesModel, StkProcessModel, ProcessState;
import 'package:kite_bird/requests/models/requests_models.dart';
import 'package:kite_bird/response/models/response_models.dart';
import 'package:kite_bird/transactions/models/transactions_models.dart' show 
        TransactionType, TransactionState, TransactionModel, TransactionResult,
        TransactionResultStatus, TransactionChannel;
import 'package:kite_bird/wallets/modules/wallets_modules.dart' show WalletOperations;


class MpesaStkCallbackController extends ResourceController{
  @Operation.post()
  Future<Response> defaultStkCallback()async{
    final Map<String, dynamic> _body = await request.body.decode();
    _body['flag'] = "unprocessed";
    _body['type'] = "stkPush";

    final MpesaResponsesModel _mpesaResponsesModel = MpesaResponsesModel(body: _body);
    await _mpesaResponsesModel.save();

    return Response.ok({"message": "done"});
  }

  @Operation.post('requestId')
  Future<Response> stkCallback(@Bind.path("requestId") String requestId)async{
    final Map<String, dynamic> _body = await request.body.decode();

    String _recieptNo;

    bool _success = false;

    // ResultCode
    if(_body['Body'] != null && _body['Body']['stkCallback'] != null && _body['Body']['stkCallback']['ResultCode'] == 0){
      _success = true;
      
      
      final Map<String, dynamic> _head = {};
      // MerchantRequestID
      _head['MerchantRequestID'] = _body['Body']['stkCallback']['MerchantRequestID'];
      // CheckoutRequestID
      _head['CheckoutRequestID'] = _body['Body']['stkCallback']['CheckoutRequestID'];

      final _details = _body['Body']['stkCallback']['CallbackMetadata']['Item'];
      final Map<String, dynamic> _item = {};
      for(int i = 0; i < int.parse(_details.length.toString()); i++){
        _item[_details[i]['Name'].toString()] = _details[i]['Value'];

        if(_details[i]['Name'].toString() == 'MpesaReceiptNumber'){
          _recieptNo = _details[i]['Value'].toString();
        }
      }

      _body['MpesaReceiptNumber'] = _item['MpesaReceiptNumber'];

      _body['Body'] = {
        "head": _head,
        "data": _item
      };
      
      _body['flag'] = "complete";


    }
    else{
      _success = false;

    }

    processMpesaResponse(success: _success, body: _body, requestId: requestId, recieptNo: _recieptNo);

    

    return Response.ok({"message": "done"});
  }
}


void processMpesaResponse({bool success, Map<String, dynamic> body, String requestId, String recieptNo})async{
  final StkProcessModel _stkProcessModelP = StkProcessModel(requestId: requestId);
  final bool _isPending = await _stkProcessModelP.isPending();
  final ObjectId transactionId = ObjectId();
  final RequestsModel _requestsModel = RequestsModel();


  final Map<String, dynamic> _transactionMeta = await _requestsModel.findById(requestId);
  String walletAccountNo;
  String transactionDesc;
  String phoneNo;
  double amount;
  String _url;

  walletAccountNo = _transactionMeta['body']['metadata']['walletNo'].toString();
  transactionDesc = _transactionMeta['body']['metadata']['transactionDesc'].toString();
  phoneNo = _transactionMeta['body']['metadata']['phoneNo'].toString();
  amount = double.parse(_transactionMeta['body']['metadata']['amount'].toString());
  _url = _transactionMeta['body']['metadata']['callBackUrl'].toString();
  

  body['walletNo'] = walletAccountNo;
  body['transactionDesc'] = transactionDesc;
  body['amount'] = amount;


  
  if(success){
      body['_id'] = transactionId;
    final MpesaResponsesModel _mpesaResponsesModel = MpesaResponsesModel(body: body);
    await _mpesaResponsesModel.save();
    // deposit to wallet
    final WalletOperations _walletOperations = WalletOperations(
      amount: amount,
      sender: phoneNo,
      recipient: walletAccountNo,
      transactionType: TransactionType.mpesaCb,
    );
    await _walletOperations.deposit();

    // Update stkProcess
    final StkProcessModel _stkProcessModel = StkProcessModel(requestId: requestId, processState: ProcessState.complete);
    _stkProcessModel.updateProcessStateByRequestId();


  } else{
    if(body != null){
      body['_id'] = transactionId;
      final MpesaResponsesModel _mpesaResponsesModel = MpesaResponsesModel(body: body);
      await _mpesaResponsesModel.save();
    }

    // Update stkProcess
    final StkProcessModel _stkProcessModel = StkProcessModel(requestId: requestId, processState: ProcessState.failed);
    _stkProcessModel.updateProcessStateByRequestId();
  }

   // save transaction
  final TransactionModel _transactionModel = TransactionModel(
    amount: amount,
    cost: 0,
    recipientNo: walletAccountNo,
    senderNo: phoneNo,
    transactionType: TransactionType.mpesaCb,
    state: success ? TransactionState.complete: TransactionState.failed
  );

  await _transactionModel.save();

  // Save response
  final TransactionResult _transactionResult = TransactionResult(
    resultStatus: success ? TransactionResultStatus.complete : TransactionResultStatus.failed,
    reqRef: requestId,
    transactionId: transactionId.toJson(),
    channel: TransactionChannel.mpesa,
    paymentRef: walletAccountNo,
    receiptRef: recieptNo.toString(), 
    amount: success ? amount.toString() : null,
    charges: '0',
    receiverParty: "Mpesa",
    senderAccount: phoneNo,
    receiptNo: recieptNo.toString(),
    completeDateTime: DateTime.now().toString(),
    currentBalance: null,
    availableBalance: null,
  );

  await _transactionResult.save();

  
  if(_isPending){
  // Send to callback url
    try{
    // final dynamic _res = 
    await http.post(_url, body: json.encode({"status": success ? 0: 1, "body": _transactionResult.asMap()}), headers: {'content-type': 'application/json',});

    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: requestId,
      responseType: ResposeType.callBack,
      responseBody: {
        'endpoint': _url,
        'status': 'success',
        'body': {"status": success ? 0: 1, "body": _transactionResult.asMap()}
      },
      status: ResponsesStatus.success
    );

    await _responsesModel.save();
    } catch (e){
      print(e);
      final ResponsesModel _responsesModel = ResponsesModel(
      requestId: requestId,
      responseType: ResposeType.callBack,
      responseBody: {
        'endpoint': _url,
        'status': 'failed',
        'body': e.toString()
      },
      status: ResponsesStatus.success
    );

    await _responsesModel.save();
    rethrow;
    }
  }

}
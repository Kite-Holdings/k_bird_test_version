import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/flutterwave/flutterwave_response_model.dart';
import 'package:kite_bird/models/requests_model.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/transaction/transaction_model.dart';
import 'package:kite_bird/models/transaction/transaction_result_model.dart';
import 'package:kite_bird/models/wallets/wallet_operations.dart';

class FlutterWaveResponseController  extends ResourceController{
  String _requestId;
  final ResposeType _responseType = ResposeType.callBack;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  @Operation.post()
  Future<Response> operation()async {
    final Map<String, dynamic> _body = await request.body.decode();
    final ObjectId _transId = ObjectId();
    _body['_id'] = _transId;
    final FlutterwaveResponseModel _flutterwaveResponseModel = FlutterwaveResponseModel(body: _body);
    await _flutterwaveResponseModel.save();
    final String _transactionId = _transId.toJson();


    _requestId = _body['txRef'].toString();
    final String _recieptNo = _body['flwRef'].toString();
    
    final RequestsModel _requestModel = RequestsModel();
    final Map<String, dynamic> _data = await _requestModel.findById(_body['txRef'].toString());
    final String walletNo = _data['body']['metadata']['walletNo'].toString();
    final String amount = _data['body']['metadata']['amount'].toString();
    final String cardNo = _data['body']['metadata']['cardNo'].toString();
    final String _url = _data['body']['metadata']['callbackUrl'].toString();

    // deposit wallet
    final WalletOperations _walletOperations = WalletOperations(
      amount: double.parse(amount),
      recipient: walletNo,
      sender: cardNo,
      transactionType: TransactionType.cardToWallet
    );
    if(!await _walletOperations.deposit()){
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "unable to deposit to wallet"};
      final ResponsesModel _responsesModel = ResponsesModel(
        requestId: _requestId,
        responseType: _responseType,
        responseBody: _responseBody,
        status: _responseStatus,
      );

      await _responsesModel.save();
      // Save transaction
      final TransactionModel transactionModel = TransactionModel(
        amount: double.parse(amount),
        cost: 0,
        recipientNo: walletNo,
        senderNo: cardNo,
        transactionType: TransactionType.cardToWallet,
        state: TransactionState.failed
      );
      await transactionModel.save();
    }
    else{
      // Save transaction
      final TransactionModel transactionModel = TransactionModel(
        amount: double.parse(amount),
        cost: 0,
        recipientNo: walletNo,
        senderNo: cardNo,
        transactionType: TransactionType.cardToWallet,
        state: TransactionState.complete
      );
      await transactionModel.save();
    }

    

    final TransactionResult _transactionResult = TransactionResult(
      resultStatus: TransactionResultStatus.complete,
      reqRef: _requestId,
      transactionId: _transactionId,
      channel: TransactionChannel.card,
      paymentRef: walletNo,
      receiptRef: _recieptNo, 
      amount: amount.toString(),
      charges: '0',
      receiverParty: "KiteWallet",
      senderAccount: cardNo,
      receiptNo: _recieptNo,
      completeDateTime: DateTime.now().toString(),
      currentBalance: null,
      availableBalance: null,
    );


    await _transactionResult.save();

    // Send to callback url
     try{
      _responseStatus = ResponsesStatus.information;
      _responseBody = {'body': _transactionResult.asMap()};
      // _responseBody['status'] = 0;
      await http.post(_url, body: json.encode(_responseBody), headers: {'content-type': 'application/json',});
      _responseBody = {
        'endpoint': _url,
        'status': 'success',
        'body': _transactionResult.asMap()
      };

     } catch (e){
       print(e);
       _responseStatus = ResponsesStatus.warning;
      _responseBody = {
        'endpoint': _url,
        'status': 'failed',
        'body': e.toString()
      };
     }
     final ResponsesModel _responsesModel = ResponsesModel(
       requestId: _requestId,
       responseType: _responseType,
       responseBody: _responseBody,
       status: _responseStatus,
     );

     await _responsesModel.save();
    

    return Response.ok({"message": "done"});

  }
}
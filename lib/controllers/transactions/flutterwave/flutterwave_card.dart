import 'dart:convert';

import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/response_model.dart';
import 'package:kite_bird/models/wallets/wallet_model.dart';
import 'package:kite_bird/requests_managers/fluterwave_requests.dart';
import 'package:kite_bird/serializers/flutterwave/flutterwave_card_serializer.dart';
import 'package:kite_bird/third_party_operations/flutterwave/flutterwave_operations.dart';
import 'package:pedantic/pedantic.dart';

class FlutterWaveCardTransactionController extends ResourceController{

  String _requestId;
  final ResposeType _responseType = ResposeType.card;
  ResponsesStatus _responseStatus;
  dynamic _responseBody;

  @Operation.post()
  Future<Response> card(
    @Bind.body(require: ['cardNo', 'cvv', 'expiryMonth', 'expiryYear', 'amount', 'email', 'walletNo', 'callbackUrl'])
    FlutterwaveCardSerializer flutterwaveCardSerializer
    )async{
      // save request
    final FlutterwaveRequests _flutterwaveRequests = FlutterwaveRequests(
      account: null,
      metadata: {
        'amount': flutterwaveCardSerializer.amount,
        'cardNo': flutterwaveCardSerializer.cardNo,
        'email': flutterwaveCardSerializer.email,
        'currency': 'KES',
        'country': 'KE',
        'walletNo': flutterwaveCardSerializer.walletNo,
        'callbackUrl': flutterwaveCardSerializer.callbackUrl 
      }
    );
    _flutterwaveRequests.normalRequest();
    _requestId = _flutterwaveRequests.requestId();
    // check if wallet exist
    final WalletModel walletModel = WalletModel();
    final bool walletExist =await walletModel.exists(where.eq('walletNo', flutterwaveCardSerializer.walletNo));
    if(!walletExist){
      _responseStatus = ResponsesStatus.failed;
      _responseBody = {"body": "Recipient Account does not exist"};
    } else{
      // transact
      final FlutterWaveCardDeposit _flutterWaveCardDeposit = FlutterWaveCardDeposit(
        amount: flutterwaveCardSerializer.amount,
        callbackUrl: flutterwaveCardSerializer.callbackUrl,
        cardNo: flutterwaveCardSerializer.cardNo,
        cvv: flutterwaveCardSerializer.cvv,
        email: flutterwaveCardSerializer.email,
        expiryMonth: flutterwaveCardSerializer.expiryMonth,
        expiryYear: flutterwaveCardSerializer.expiryYear,
        walletNo: flutterwaveCardSerializer.walletNo,
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
    }
    // save response
    final ResponsesModel _responsesModel = ResponsesModel(
      requestId: _requestId,
      responseType: _responseType,
      responseBody: _responseBody,
      status: _responseStatus
    );

    unawaited(_responsesModel.save());

    return _responsesModel.sendResponse();

  }
}
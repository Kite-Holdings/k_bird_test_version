import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:kite_bird/bank/configs/bank_config.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show fetchCoopToken;
import 'package:kite_bird/kite_bird.dart';
import 'package:http/http.dart' as http;

class BankPesalinkModule{

  BankPesalinkModule({
    this.accountNumber,
    this.bankCode,
    this.amount,
    this.transactionCurrency = 'KES',
    this.narration,
    this.requestId,
  });


  String messageReference;
  String callBackUrl;
  String accountNumber;
  String bankCode;
  int amount;
  String transactionCurrency;
  String narration;
  String requestId;

  String transactionType;
  String transactionAction;

  Future get send => _transact();

  Future _transact() async{
    final String callBackURL = coopCallbackUrl;
    final String _accNumber = coopAccountNumber;
    final String _url = peaslinkUrl;
    final String _accessToken = await fetchCoopToken();
    // final String _accessToken = bearerToken;

    messageReference = requestId;


    final Map<String, dynamic> payload = {
      "MessageReference": messageReference,
      "CallBackUrl": callBackURL,
      "Source": {
        "AccountNumber": _accNumber,
        "Amount": amount,
        "TransactionCurrency": transactionCurrency,
        "Narration": narration
      },
      "Destinations": [
        {
          "ReferenceNumber": '${messageReference}_1',
          "AccountNumber": accountNumber,
          "BankCode": bankCode,
          "Amount": amount,
          "TransactionCurrency": transactionCurrency,
          "Narration": narration
        }
      ]
    };

    final Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
    };
    const bool trustSelfSigned = true;
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    final IOClient ioClient = IOClient(httpClient);

    try{
      final http.Response r = await ioClient.post(_url, headers: headers, body: json.encode(payload));
      // var r = await http.post(_url, headers: headers, body: json.encode(payload));
      // print(r);
      // print(r.statusCode);
      // print(r.body);
      try{
        return {
          'status': 0,
          'body': json.decode(r.body)
        };
      } catch (e){
        return {
          'status': 0,
          'body': r.body
        };
      }
    } catch (e){
      return {'status': 1};
    }

  }
}
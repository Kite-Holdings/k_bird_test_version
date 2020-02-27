import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:kite_bird/bank/configs/bank_config.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show fetchCoopToken;
import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateBankModel;
import 'package:kite_bird/cooprates/modules/cooprates_modules.dart' show CooprateAccountConfModule;
import 'package:kite_bird/kite_bird.dart';
import 'package:http/http.dart' as http;

class BankMpesaModule{

  BankMpesaModule({
    this.phoneNo,
    this.amount,
    this.cooprateCode,
    this.narration,
    this.transactionCurrency,
    this.requestId,
  });


  String messageReference;
  String callBackUrl;
  String phoneNo;
  String cooprateCode;
  int amount;
  String transactionCurrency;
  String narration;
  String requestId;

  String transactionType;
  String transactionAction;

  Future get send => _transact();

  Future _transact() async{
    // fetch configs
    final CooprateAccountConfModule _accountConfModule = CooprateAccountConfModule(cooprateCode: cooprateCode);
    final CooprateBankModel _conf = await _accountConfModule.bankConf();

    final String _accountNumber = _conf.accountNumber;
    final String _key = _conf.consumerKey;
    final String _secret = _conf.consumerSecret;

    final String callBackURL = coopCallbackUrl;
    final String _url = coopMpesaUrl;
    final String _accessToken = await fetchCoopToken(key: _key, secret: _secret);

    messageReference = requestId;


    final Map<String, dynamic> payload = {
      "MessageReference": messageReference,
      "CallBackUrl": callBackURL,
      "Source": {
        "AccountNumber": _accountNumber,
        "Amount": amount,
        "TransactionCurrency": transactionCurrency,
        "Narration": narration
      },
      "Destinations": [
        {
          "ReferenceNumber": '${messageReference}_1',
          "MobileNumber": phoneNo,
          "Amount": amount,
          "Narration": narration
        }
      ]
    };

    // print(json.encode(payload));

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
      print("//////////////////////////////////////////////");
      print(r.body);
      print(r.statusCode);
      print("//////////////////////////////////////////////");
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
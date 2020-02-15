import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:kite_bird/bank/configs/bank_config.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show fetchCoopToken;
import 'package:kite_bird/kite_bird.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:http/http.dart' as http;

Future checkBalance() async {
  final String _accessToken = await fetchCoopToken();
  final Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
  };

  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "AccountNumber": coopAccountNumber
  };


  const bool trustSelfSigned = true;
  final HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  final IOClient ioClient = IOClient(httpClient);
  try{
    final http.Response r = await ioClient.post(accountBalanceUrl, headers: headers, body: json.encode(payload));
    return json.decode(r.body);
  } catch (e){
    return e.toString();
  }

}
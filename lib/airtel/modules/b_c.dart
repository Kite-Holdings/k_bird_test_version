import 'package:kite_bird/kite_bird.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Response> airtelBTocTransaction({
  String customerNo,
  String merchantNo,
  double amount,
  String pin,
}) async {
  final String payload = 
  '''
  <COMMAND>
  <TYPE>B2C</TYPE>
  <CUSTOMERMSISDN>$customerNo</CUSTOMERMSISDN>
  <MERCHANTMSISDN>$merchantNo</MERCHANTMSISDN>
  <AMOUNT>$amount</AMOUNT>
  <PIN>$pin</PIN>
  <REFERENCE>test001</REFERENCE>
  <USERNAME>test</USERNAME>
  <PASSWORD>test@123</PASSWORD>
  <REFERENCE1>qwertyui</REFERENCE1>
  </COMMAND>
  ''';

  final Map<String, String> headers = {
      'content-type': 'text/xml',
  };

  const String url = "https://41.223.58.182:9193/MerchantPaymentService.asmx";
  const bool trustSelfSigned = true;
  final HttpClient httpClient =  HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  final IOClient ioClient =  IOClient(httpClient);

  print(payload);
  

  final http.Response res = await ioClient.post(url, headers: headers, body: payload);

  return res;
}
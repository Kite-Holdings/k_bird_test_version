import 'package:kite_bird/kite_bird.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Response> airtelEnrol() async {
  const String payload = 
  '''
  <COMMAND>
  <TYPE>CKYCREQ</TYPE>
  <MSISDN>701555550</MSISDN>
  <EXTREQ>Y</EXTREQ>
  <PROVIDER>101</PROVIDER>
  <USERNAME>test</USERNAME>
  <PASSWORD>test@123</PASSWORD>
  </COMMAND>
  ''';

  final Map<String, String> headers = {
      'content-type': 'text/xml',
  };

  const String url = "https://41.223.58.182:9193/MerchantPaymentService.asmx";
  const bool trustSelfSigned = true;
  final HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  final IOClient ioClient = IOClient(httpClient);
  

  final http.Response res = await ioClient.post(url, headers: headers, body: payload);

  return res;
}
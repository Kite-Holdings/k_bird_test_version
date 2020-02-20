import 'package:kite_bird/airtel/modules/airtel_modules.dart' show airtelBTocTransaction;
import 'package:kite_bird/airtel/serializers/airtel_serializers.dart' show AirtellBCSerializer;
import 'package:http/http.dart' as http;
import 'package:kite_bird/kite_bird.dart';

class AirtelBCController extends ResourceController{

  @Operation.post()
  Future<Response> bc(@Bind.body(require: ['customerNo', 'merchantNo', 'amount', 'pin']) AirtellBCSerializer airtellBCSerializer)async{
    final http.Response _res =  await airtelBTocTransaction(
      customerNo: airtellBCSerializer.customerNo,
      merchantNo: airtellBCSerializer.merchantNo,
      amount: airtellBCSerializer.amount,
      pin: airtellBCSerializer.pin,
    );
    return Response(_res.statusCode, _res.headers, _res.body);
  }
}
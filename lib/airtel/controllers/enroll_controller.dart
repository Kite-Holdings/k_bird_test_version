import 'package:kite_bird/airtel/modules/airtel_modules.dart' show airtelEnrol;
import 'package:http/http.dart' as http;
import 'package:kite_bird/kite_bird.dart';

class AirtelEnrollController extends ResourceController{

  @Operation.post()
  Future<Response> enroll()async{
    final http.Response _res =  await airtelEnrol();
    return Response(_res.statusCode, _res.headers, _res.body);
  }
}
import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/cellulant/modules/cellulant_modules.dart' show CellulantQueryBillModule;
import 'package:kite_bird/cellulant/serializers/cellulant_serializers.dart' show CellulantQueryBillSerializer;

class CellulantQueryBillController extends ResourceController{
  @Operation.post()
  Future<Response> validate(@Bind.body(require: ['accountNumber', 'serviceID']) CellulantQueryBillSerializer cellulantQueryBillSerializer)async{
    final CellulantQueryBillModule _cellulantQueryBillModule = CellulantQueryBillModule(
      accountNumber: cellulantQueryBillSerializer.accountNumber,
      serviceID: cellulantQueryBillSerializer.serviceID,
    );
    final Map<String, dynamic> _cellulantRes = await _cellulantQueryBillModule.query();
    switch (int.parse(_cellulantRes['status'].toString())) {
      case 0:
        return Response.ok(_cellulantRes);
        break;
      case 101:
        return Response.badRequest(body: _cellulantRes);
        break;
      case 2:
        return Response.badRequest(body: _cellulantRes);
        break;      
      default:
        return Response.serverError(body: _cellulantRes);
    }
  }
}
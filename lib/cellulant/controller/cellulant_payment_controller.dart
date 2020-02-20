import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/cellulant/modules/cellulant_modules.dart' show CellulantPaymentModule;
import 'package:kite_bird/cellulant/serializers/cellulant_serializers.dart' show CellulantPaymentSerializer;

class CellulantPaymentController extends ResourceController{
  @Operation.post()
  Future<Response> validate(@Bind.body(require: ['phoneNo', 'accountNumber', 'amount', 'serviceID']) CellulantPaymentSerializer cellulantPaymentSerializer)async{
    final CellulantPaymentModule _cellulantPaymentModule = CellulantPaymentModule(
      phoneNo: cellulantPaymentSerializer.phoneNo,
      accountNumber: cellulantPaymentSerializer.accountNumber,
      serviceID: cellulantPaymentSerializer.serviceID,
      amount: cellulantPaymentSerializer.amount,
    );
    final Map<String, dynamic> _cellulantRes = await _cellulantPaymentModule.pay();
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
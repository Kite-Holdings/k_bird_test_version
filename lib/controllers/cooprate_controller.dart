import 'package:kite_bird/kite_bird.dart';
import 'package:kite_bird/models/cooprate_model.dart';
import 'package:kite_bird/serializers/cooprate_serializer.dart';

class CooprateController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();
  @Operation.get()
  Future<Response> getAll()async{
    return Response.ok(await cooprateModel.find());
    }

  @Operation.get('cooprateId')
  Future<Response> getOne(@Bind.path("cooprateId") String cooprateId)async{
    final Map<String, dynamic> _dbRes = await cooprateModel.findById(cooprateId);
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }

  @Operation.post()
  Future<Response> registerCompany(@Bind.body(require: ['name']) CoopratesSerializer coopratesSerializer)async{
    final CooprateModel _cooprateModel = CooprateModel(name: coopratesSerializer.name);
    await _cooprateModel.init();
    final Map<String, dynamic> _dbRes = await _cooprateModel.save();
    if(_dbRes['status'] == 0){
      return Response.ok({'status': 0, 'body': "Cooprate saved."});
    } else {
      if(_dbRes['body']['code'] == 11000){
        return Response.badRequest(body: {'status': 1, 'body': "name exixts"});
      } else {
        return Response.badRequest(body: {'status': 1, 'body': 'An error occured!'});
      }
    }
  }

  @Operation.delete('cooprateId')
  Future<Response> delete(@Bind.path("cooprateId") String cooprateId)async{
    final Map<String, dynamic> _dbRes = await cooprateModel.remove(where.id(ObjectId.parse(cooprateId)));
      if(_dbRes['status'] == 0){
        return Response.ok({"status": 0, "body": "deleted successfully"});
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }


}

class CooprateFindByController extends ResourceController{
  CooprateModel cooprateModel = CooprateModel();
  @Operation.get('cooprateName')
  Future<Response> getByNameSelector(@Bind.path("cooprateName") String cooprateName)async{
    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('name', cooprateName));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }
  @Operation.get('cooprateCode')
  Future<Response> getByCodeSelector(@Bind.path("cooprateCode") String cooprateCode)async{
    final Map<String, dynamic> _dbRes = await cooprateModel.findBySelector(where.eq('code', cooprateCode));
      if(_dbRes['status'] == 0){
        return Response.ok(_dbRes);
      } else {
        return Response.badRequest(body: {"status": 1, "body": "invalid id"});
      }
  }
}
import 'package:kite_bird/models/model.dart';

class StkQuerResponseModel extends Model{
  StkQuerResponseModel({this.body}) : super(dbUrl: databaseUrl, collectionName: stkQueryResponseCollection){
    super.document = body;
  }
  final Map<String, dynamic> body;
}
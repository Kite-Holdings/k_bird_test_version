import 'package:kite_bird/models/model.dart';

class MpesaResponsesModel extends Model{
  MpesaResponsesModel({this.body}) : super(dbUrl: databaseUrl, collectionName: mpesaResponsesCollection){
    super.document = body;
  }
  final Map<String, dynamic> body;
}
import 'package:kite_bird/models/model.dart';

class BankResponsesModel extends Model{
  BankResponsesModel({this.body}) : super(dbUrl: databaseUrl, collectionName: bankResponsesCollection){
    super.document = body;
  }
  final Map<String, dynamic> body;
}
import 'package:kite_bird/models/model.dart';

class FlutterwaveResponseModel extends Model{
  FlutterwaveResponseModel({this.body}) : super(dbUrl: databaseUrl, collectionName: flutterwaveResponsesCollection){
    super.document = body;
  }
  final Map<String, dynamic> body;
}
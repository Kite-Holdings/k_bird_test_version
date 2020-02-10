import 'package:kite_bird/businesses/models/business_models.dart' show BusinessWalletModel;
import 'package:kite_bird/models/utils/database_collection_names.dart';
import 'package:kite_bird/models/utils/increment_counter.dart';

class CreateBusinessWalletModule{
  CreateBusinessWalletModule({this.businessId});

  final String businessId;
  String shortCode;

  Future<String> createBusinessShortCode()async{
    // businessesShortcodeCountCollection
    final int _count = await databaseCounter(businessesShortcodeCountCollection);
    final String _shortCode = _count.toString().padLeft(6, '0');
    return _shortCode;
  }

  Future<bool> create()async{
    shortCode = await createBusinessShortCode();

    final BusinessWalletModel businessWalletModel = BusinessWalletModel(
      businessId: businessId,
      shortCode: shortCode
    );

    final Map<String, dynamic> _busWalletRes = await businessWalletModel.save();
    if(_busWalletRes['status'] == 0){
      return true;
    }else{
      return false;
    }
  }

}
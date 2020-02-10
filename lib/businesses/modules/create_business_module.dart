import 'package:kite_bird/businesses/models/business_models.dart' show BusinessModel, BusinessState, ObjectId;
import 'package:kite_bird/businesses/modules/business_modules.dart' show CreateBusinessWalletModule;

class CreateBussinessModule{
  CreateBussinessModule({
    this.name, 
    this.uid, 
    this.cooprateCode, 
    this.state = BusinessState.basic,
    });
  final String name;
  final String uid;
  final String cooprateCode;
  final BusinessState state;

  ObjectId businessId;
  String walletShortCode;

  Future<bool> create()async{

    // create business
    final BusinessModel businessModel = BusinessModel(
      name: name,
      uid: uid,
      cooprateCode: cooprateCode,
      state: state,
    );

    final Map<String, dynamic> _businessRes = await businessModel.save();

    if(_businessRes['status'] == 0){
      businessId = businessModel.id;
      // create business wallet
      final CreateBusinessWalletModule createBusinessWalletModule = CreateBusinessWalletModule(
        businessId: businessId.toJson()
      );

      final bool _walletCreated = await createBusinessWalletModule.create();
      if(_walletCreated){
        walletShortCode = createBusinessWalletModule.shortCode;
        return true;

      } else{
        return false;
      }
      
    } else{
      return false;
    }

  }


}
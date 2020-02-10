import 'package:kite_bird/businesses/models/business_models.dart' show
 BusinessStaffModel, 
 BusinessStaffRole, 
 BusinessStaffAccountState;
 
export 'package:kite_bird/businesses/models/business_models.dart' show
 BusinessStaffModel, 
 BusinessStaffRole, 
 BusinessStaffAccountState;

class CreateBusinessStaffModule{
  CreateBusinessStaffModule({
    this.businessId, 
    this.phoneNo, 
    this.businessStaffRole, 
    this.accountState,
    });
  final String businessId;
  final String phoneNo;
  final BusinessStaffRole businessStaffRole;
  final BusinessStaffAccountState accountState;

  Future<bool> create()async{
    final BusinessStaffModel businessStaffModel = BusinessStaffModel(
      businessId: businessId,
      phoneNo: phoneNo,
      businessStaffRole: businessStaffRole,
      accountState: accountState,
    );

    final Map<String, dynamic> _res = await businessStaffModel.save();
    if(_res['status'] == 0){
      return true;
    } else {
      return false;
    }

  }

}

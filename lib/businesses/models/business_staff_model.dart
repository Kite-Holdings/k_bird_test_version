import 'package:kite_bird/models/model.dart';

class BusinessStaffModel extends Model{

  BusinessStaffModel({
    this.phoneNo,
    this.accountState,
    this.businessId,
    this.businessStaffRole
  }):super(dbUrl: databaseUrl, collectionName: businessStaffsCollection){
    id = ObjectId();
    super.document = asMap();
  }

  ObjectId id;
  final String businessId;
  final String phoneNo;
  final BusinessStaffRole businessStaffRole;
  final BusinessStaffAccountState accountState;

  Map<String, dynamic> asMap()=>{
    '_id': id,
    'phoneNo': phoneNo,
    'businessId': businessId,
    'accountState': stringBusinessStaffAccountState(),
    'businessStaffRole': stringBusinessStaffRole(),
  };

  BusinessStaffModel fromMap(Map<String, dynamic> object){
    return BusinessStaffModel(
      phoneNo: object['phoneNo'].toString(),
      businessId: object['businessId'].toString(),
      accountState: businessStaffAccountStateFromString(object['accountState'].toString()),
      businessStaffRole: businessStaffRoleFromSring(object['businessStaffRole'].toString()),
    );
  }





  String stringBusinessStaffRole(){
    switch (businessStaffRole) {
      case BusinessStaffRole.admin:
        return 'admin';
        break;
      case BusinessStaffRole.guest:
        return 'guest';
        break;
      case BusinessStaffRole.moderator:
        return 'moderator';
        break;
      case BusinessStaffRole.normal:
        return 'normal';
        break;
      default:
        return 'anonymous';
    }
  }

  BusinessStaffRole businessStaffRoleFromSring(String value){
    switch (value) {
      case 'admin':
        return BusinessStaffRole.admin;
        break;
      case 'guest':
        return BusinessStaffRole.guest;
        break;
      case 'moderator':
        return BusinessStaffRole.moderator;
        break;
      case 'normal':
        return BusinessStaffRole.normal;
        break;
      default:
        return BusinessStaffRole.anonymous;
    }
  }
  

  String stringBusinessStaffAccountState(){
    switch (accountState) {
      case BusinessStaffAccountState.active:
        return 'active';
        break;
      default:
       return 'inactive';
    }
  }
  BusinessStaffAccountState businessStaffAccountStateFromString(String value){
    switch (value) {
      case 'active':
        return BusinessStaffAccountState.active;
        break;
      default:
       return BusinessStaffAccountState.inactive;
    }
  }
  
}

enum BusinessStaffRole{
  admin,
  moderator,
  normal,
  guest,
  anonymous,
}

enum BusinessStaffAccountState{
  active,
  inactive
}
import 'package:fishing_boats_app/authentication/models/user.dart';

class Branch extends Object {
  String code;
  String name;

  Branch(this.code, this.name);

  Branch.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.code = json['code'].toString();
    this.name = json['name'];
  }

  Branch.fromSimpleMap(Map<String, dynamic> json){
    this.code = json['code'] != null ? json['code'] : '';
    this.name = json['name'] != null ? json['name'] : '';
  }

  @override
  String toString() {
    return 'Branch{code: $code, name: $name}';
  }
}

class UserBranch extends Object {
  User user;
  Branch branch;
  String state;

  UserBranch(this.user, this.branch, this.state);

  UserBranch.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.user =
        json['user'] != null ? User.fromFishBackEndApiRest(json['user']) : null;
    this.branch = json['branch'] != null
        ? Branch.fromFishBackEndApiRest(json['branch'])
        : null;
    this.state = json['state'];
  }

  @override
  String toString() {
    return 'UserBranch{user: $user, branch: $branch, state: $state}';
  }
}

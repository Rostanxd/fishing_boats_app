import 'package:fishing_boats_app/authentication/models/role.dart';

class User extends Object {
  String code;
  String user;
  String names;
  Role role;

  User(this.code, this.user, this.names);

  User.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.code = json['code'].toString();
    this.user = json['user'];
    this.names = json['name'];
    this.role =
        json['role'] != null ? Role.fromFishBackEndApiRest(json['role']) : null;
  }

  @override
  String toString() {
    return 'User{code: $code, user: $user, names: $names}';
  }
}

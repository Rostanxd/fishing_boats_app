class User extends Object {
  String code;
  String user;
  String names;

  User(this.code, this.user, this.names);

  User.fromFishBackEndApiRest(Map<String, dynamic> json){
    this.code = json['CODIGO'].toString();
    this.user = json['USUARIO'];
    this.names = json['NOMBRE'];
  }

  @override
  String toString() {
    return 'User{code: $code, user: $user, names: $names}';
  }

}
class Employed extends Object {
  String id;
  String firstName;
  String lastName;

  Employed(this.id, this.firstName, this.lastName);

  Employed.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.id = json['id'].toString();
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
  }

  Employed.fromSimpleMap(Map<String, dynamic> json) {
    this.id = json['id'] != null ? json['id'] : '';
    this.firstName = json['firstName'] != null ? json['firstName'] : '';
  }

  @override
  String toString() {
    return 'Employed{id: $id, firstName: $firstName, lastName: $lastName}';
  }
}

class Program extends Object {
  String code;
  String name;

  Program(this.code, this.name);

  Program.fromFishBackEndApiRest(Map<String, dynamic> json){
    this.code = json['code'].toString();
    this.name = json['name'];
  }

  @override
  String toString() {
    return 'Program{code: $code, name: $name}';
  }

}
class Program extends Object {
  String code;
  String name;
  String path;
  int icon;

  Program(this.code, this.name, this.path, this.icon);

  Program.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.code = json['code'].toString();
    this.name = json['name'];
    this.path = json['path'];
    this.icon = json['icon'];
  }

  @override
  String toString() {
    return 'Program{code: $code, name: $name, path: $path, icon: $icon}';
  }
}

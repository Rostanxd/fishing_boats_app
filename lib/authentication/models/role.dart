import 'package:fishing_boats_app/authentication/models/program.dart';

class Role extends Object {
  String code;
  String name;

  Role(this.code, this.name);

  Role.fromFishBackEndApiRest(Map<String, dynamic> json) {
    this.code = json['code'].toString();
    this.name = json['name'];
  }

  @override
  String toString() {
    return 'Role{code: $code, name: $name}';
  }
}

class AccessByRole extends Object {
  Role role;
  Program program;
  String execute;
  String register;
  String edit;
  String delete;
  String process;

  AccessByRole(this.role, this.program, this.execute, this.register, this.edit,
      this.delete, this.process);

  AccessByRole.fromFishBackEndApiRest(Map<String, dynamic> jsonData) {
    this.role = jsonData['role'] != null
        ? Role.fromFishBackEndApiRest(jsonData['role'])
        : null;
    this.program = jsonData['program'] != null
        ? Program.fromFishBackEndApiRest(jsonData['program'])
        : null;
    this.execute = jsonData['execute'];
    this.register = jsonData['register'];
    this.edit = jsonData['edit'];
    this.delete = jsonData['delete'];
    this.process = jsonData['process'];
  }

  @override
  String toString() {
    return 'AccessByRole{role: $role, program: $program, execute: '
        '$execute, register: $register, edit: $edit, delete: $delete, '
        'process: $process}';
  }
}

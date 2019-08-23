import 'dart:convert';

import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/connection.dart';
import 'package:http/http.dart' as http;

class AuthenticationFishBackEnd {
  Future<User> logIn(String user, String password, String deviceId) async {
    final response = await http
        .get('${Connection.host}:${Connection.port}/maintenance/login/'
            '$user/$password/$deviceId');
    if (response.statusCode == 200) {
      return User.fromFishBackEndApiRest(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Failed to login. Status: ${response.statusCode}');
    }
  }

  Future<void> logOut(String user, String deviceId) async {
    final response = await http
        .get('${Connection.host}:${Connection.port}/maintenance/logOut/'
            '$user/$deviceId');
    if (response.statusCode != 200) {
      throw Exception('Error finalizando la sesión.');
    }
  }

  Future<User> authenticatedUser(String deviceId) async {
    final response = await http.get(
        '${Connection.host}:${Connection.port}/maintenance/userAuthenticated/'
        '$deviceId');
    if (response.statusCode == 200) {
      return User.fromFishBackEndApiRest(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      return null;
    }
  }

  Future<List<AccessByRole>> fetchAccessByRole(Role role) async {
    List<AccessByRole> accessList = List<AccessByRole>();
    List data;
    final response = await http.get(
        '${Connection.host}:${Connection.port}/maintenance/accessByRole/${role.code}');

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        accessList.add(AccessByRole.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Failed fetching access. Status: ${response.statusCode}');
    }

    return accessList;
  }
}

import 'dart:convert';

import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/connection.dart';
import 'package:http/http.dart' as http;

class AuthenticationFishBackEnd {
  Future<User> logIn(String user, String password) async {
    final response = await http.get(
        '${Connection.host}:${Connection.port}/maintenance/login/$user/$password');
    if (response.statusCode == 200) {
      return User.fromFishBackEndApiRest(json.decode(response.body));
    } else {
      throw Exception('Failed to login. Status: ${response.statusCode}');
    }
  }
}

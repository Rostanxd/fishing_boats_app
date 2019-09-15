import 'dart:convert';

import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/connection.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:http/http.dart' as http;

class BranchApi {
  final _httpClient = new http.Client();

  Future<List<Branch>> fetchBranches(String name) async {
    List<Branch> branchList = List<Branch>();
    List data;

    final response = await _httpClient.get(
        '${Connection.host}:${Connection.port}/orders/branches/?'
            'name=$name',
        headers: {
          "Content-type": "application/json",
          "charset": "utf-8",
          "Accept-Charset": "utf-8"
        });

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        branchList.add(Branch.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo las bodegas.');
    }
    return branchList;
  }

  Future<List<Branch>> fetchBranchesByUser(User user, String name) async {
    List<Branch> branchList = List<Branch>();
    List data;

    final response = await http.get(
        '${Connection.host}:${Connection.port}/orders/branches_by_user/'
            '${user.code}/'
            '?name=$name');

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        branchList.add(Branch.fromFishBackEndApiRest(d['branch']));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo las bodegas.');
    }
    return branchList;
  }
}

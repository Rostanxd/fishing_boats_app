import 'dart:convert';

import 'package:fishing_boats_app/models/connection.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:http/http.dart' as http;

class EmployedApi {
  final _httpClient = http.Client();

  Future<List<Employed>> fetchEmployees(String name) async {
    List<Employed> employedList = List<Employed>();
    List data;

    final response = await _httpClient.get(
        '${Connection.host}:${Connection.port}/orders/employees/$name/',
        headers: {
          "Content-type": "application/json",
          "charset": "utf-8",
          "Accept-Charset": "utf-8"
        });

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        employedList.add(Employed.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo los empleados.');
    }
    return employedList;
  }
}

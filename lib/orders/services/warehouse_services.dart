import 'dart:convert';

import 'package:fishing_boats_app/models/connection.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:http/http.dart' as http;

class WarehouseApi {
  Future<List<Warehouse>> fetchWarehouses(String name) async {
    List<Warehouse> warehouseList = List<Warehouse>();
    List data;

    final response = await http.get(
        '${Connection.host}:${Connection.port}/orders/warehouses/$name');

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        warehouseList.add(Warehouse.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo las bodegas.');
    }
    return warehouseList;
  }

  Future<List<Warehouse>> fetchTravels(String name) async {
    List<Warehouse> warehouseList = List<Warehouse>();
    List data;

    final response = await http.get(
        '${Connection.host}:${Connection.port}/orders/travels/$name');

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
      data.forEach((d) {
        warehouseList.add(Warehouse.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo las bodegas.');
    }
    return warehouseList;
  }
}

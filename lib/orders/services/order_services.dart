import 'dart:convert';
import 'package:fishing_boats_app/models/connection.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderApi {
  final formatter = new DateFormat('yyyy-MM-dd');

  Future<List<Order>> fetchOrders(Warehouse warehouse, Branch branch,
      DateTime dateFrom, DateTime dateTo) async {
    String warehouseId = warehouse != null ? warehouse.code : '';
    String branchId = branch != null ? branch.code : '';
    String dateFromSt = formatter.format(dateFrom);
    String dateToSt = formatter.format(dateTo);
    List<Order> orderList = List<Order>();
    List data;

    final response = await http.get(
        '${Connection.host}:${Connection.port}/orders/list/$warehouseId/$branchId/$dateFromSt/$dateToSt');

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      data.forEach((d) {
        orderList.add(Order.fromFishBackEndApiRest(d));
      });
    } else {
      if (response.statusCode == 404) return null;
      throw Exception('Error obteniendo las ordenes');
    }
    return orderList;
  }
}

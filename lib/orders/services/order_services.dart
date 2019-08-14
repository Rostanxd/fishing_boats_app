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
      DateTime dateFrom, DateTime dateTo, String state, String obs) async {
    String warehouseId = warehouse != null ? warehouse.code : '';
    String branchId = branch != null ? branch.code : '';
    String dateFromSt = formatter.format(dateFrom);
    String dateToSt = formatter.format(dateTo);
    List<Order> orderList = List<Order>();
    List data;

    if (state == null) state = '';
    if (obs == null) obs = '';

    final response = await http.get(
        '${Connection.host}:${Connection.port}/orders/list/'
            '$dateFromSt/$dateToSt/$warehouseId/$branchId/$state/$obs/');

    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
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

import 'dart:convert';
import 'package:fishing_boats_app/models/connection.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderApi {
  final formatter = new DateFormat('yyyy-MM-dd');

  Future<List<Order>> fetchOrders(
      int id,
      Warehouse warehouse,
      Branch branch,
      Warehouse travel,
      Employed employed,
      DateTime dateFrom,
      DateTime dateTo,
      String state,
      String obs,
      String providerName) async {
    String orderId = '';
    String warehouseId = warehouse != null ? warehouse.code : '';
    String branchId = branch != null ? branch.code : '';
    String travelId = travel != null ? travel.code : '';
    String employedId = employed != null ? employed.id : '';
    String dateFromSt = formatter.format(dateFrom);
    String dateToSt = formatter.format(dateTo.add(Duration(days: 1)));
    List<Order> orderList = List<Order>();
    List data;

    if (id != null) orderId = id.toString();
    if (state == null) state = '';
    if (obs == null) obs = '';

    final response =
        await http.get('${Connection.host}:${Connection.port}/orders/list/'
            '$dateFromSt/$dateToSt/$orderId/$warehouseId/$branchId/$travelId/'
            '$employedId/$state/$obs/$providerName/');

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

  Future<int> createOrder(Order order) async {
    int id;
    final response = await http.post(
      '${Connection.host}:${Connection.port}/orders/create/',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"order_data": "${json.encode(order.toJson())}"}),
    );
    if (response.statusCode == 200) {
      id = json.decode(utf8.decode(response.bodyBytes))['id'];
    } else {
      throw Exception('Error generando la orden');
    }
    return id;
  }

  Future<void> updateOrder(Order order) async {
    final response = await http.post(
      '${Connection.host}:${Connection.port}/orders/update/',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"order_data": "${json.encode(order.toJson())}"}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error generando la orden');
    }
  }
}

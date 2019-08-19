import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/orders/services/branch_services.dart';
import 'package:fishing_boats_app/orders/services/employed_services.dart';
import 'package:fishing_boats_app/orders/services/order_services.dart';
import 'package:fishing_boats_app/orders/services/warehouse_services.dart';

class OrdersRepository {
  final WarehouseApi _warehouseApi = WarehouseApi();
  final BranchApi _branchApi = BranchApi();
  final OrderApi _orderApi = OrderApi();
  final EmployedApi _employedApi = EmployedApi();

  Future<List<Warehouse>> fetchWarehouses(String name) =>
      _warehouseApi.fetchWarehouses(name);

  Future<List<Warehouse>> fetchTravels(String name) =>
      _warehouseApi.fetchTravels(name);

  Future<List<Branch>> fetchBranches(String name) =>
      _branchApi.fetchBranches(name);

  Future<List<Branch>> fetchBranchesByUser(User user, String name) =>
      _branchApi.fetchBranchesByUser(user, name);

  Future<List<Employed>> fetchEmployees(String name) =>
      _employedApi.fetchEmployees(name);

  Future<List<Order>> fetchOrders(
          Warehouse warehouse,
          Branch branch,
          Warehouse travel,
          Employed employed,
          DateTime dateFrom,
          DateTime dateTo,
          String state,
          String obs,
          String providerName) =>
      _orderApi.fetchOrders(warehouse, branch, travel, employed, dateFrom,
          dateTo, state, obs, providerName);

  Future<int> createOrder(Order order) => _orderApi.createOrder(order);
}

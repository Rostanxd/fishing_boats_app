import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/orders/resources/orders_repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderPageBloc extends Object implements BlocBase {
  final _user = BehaviorSubject<User>();
  final _warehouseSearch = BehaviorSubject<String>();
  final _warehouseSelected = BehaviorSubject<Warehouse>();
  final _branchSearch = BehaviorSubject<String>();
  final _branchSelected = BehaviorSubject<Branch>();
  final _stateSelected = BehaviorSubject<String>();
  final _warehousesAvailable = BehaviorSubject<List<Warehouse>>();
  final _branchesAvailable = BehaviorSubject<List<Branch>>();
  final _dateFrom = BehaviorSubject<DateTime>();
  final _dateTo = BehaviorSubject<DateTime>();
  final _orders = BehaviorSubject<List<Order>>();
  final _message = BehaviorSubject<String>();
  final OrdersRepository _ordersRepository = OrdersRepository();

  /// Observables
  ValueObservable<User> get userLogged => _user.stream;

  Observable<Warehouse> get warehouseSelected => _warehouseSelected.stream;

  Observable<Branch> get branchSelected => _branchSelected.stream;

  Observable<String> get stateSelected => _stateSelected.stream;

  Observable<List<Warehouse>> get warehousesAvailable =>
      _warehousesAvailable.stream;

  Observable<List<Branch>> get branchesAvailable => _branchesAvailable.stream;

  ValueObservable<DateTime> get dateFrom => _dateFrom.stream;

  ValueObservable<DateTime> get dateTo => _dateTo.stream;

  Observable<List<Order>> get orders => _orders.stream;

  /// Functions
  Stream<List<Warehouse>> get warehouses => _warehouseSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchWarehouses(terms);
      });

  Stream<List<Branch>> get branches => _branchSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchBranches(terms);
      });

  Stream<List<Branch>> get branchesByUser => _branchSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchBranchesByUser(_user.value, terms);
      });

  Future<void> fetchOrders() async {
    await _ordersRepository
        .fetchOrders(_warehouseSelected.value, _branchSelected.value,
            _dateFrom.value, _dateTo.value)
        .timeout(Duration(seconds: 30))
        .then((data) {
      _orders.sink.add(data);
    }).catchError((error) {
      _message.sink.add('Error: ${error.toString()}');
    });
  }

  Function(User) get changeUser => _user.add;

  Function(String) get changeWarehouseSearch => _warehouseSearch.add;

  Function(String) get changeBranchSearch => _branchSearch.add;

  Function(DateTime) get changeDateFrom => _dateFrom.add;

  Function(DateTime) get changeDateTo => _dateTo.add;

  Function(Warehouse) get changeWarehouseSelected => _warehouseSelected.add;

  Function(Branch) get changeBranchSelected => _branchSelected.add;

  void cleanFilters() {
    _warehouseSelected.sink.add(null);
    _branchSelected.sink.add(null);
    _dateFrom.sink.add(DateTime.now());
    _dateTo.sink.add(DateTime.now());
  }

  @override
  void dispose() {
    _user.close();
    _warehouseSearch.close();
    _warehouseSelected.close();
    _branchSearch.close();
    _branchSelected.close();
    _stateSelected.close();
    _warehousesAvailable.close();
    _branchesAvailable.close();
    _dateFrom.close();
    _dateTo.close();
    _orders.close();
    _message.close();
  }
}

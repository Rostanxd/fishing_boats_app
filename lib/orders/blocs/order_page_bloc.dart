import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/orders/resources/orders_repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderPageBloc extends Object implements BlocBase {
  final _user = BehaviorSubject<User>();
  final _id = BehaviorSubject<String>();
  final _warehouseSearch = BehaviorSubject<String>();
  final _warehouseSelected = BehaviorSubject<Warehouse>();
  final _branchSearch = BehaviorSubject<String>();
  final _branchSelected = BehaviorSubject<Branch>();
  final _travelSearch = BehaviorSubject<String>();
  final _travelSelected = BehaviorSubject<Warehouse>();
  final _applicantSearch = BehaviorSubject<String>();
  final _applicantSelected = BehaviorSubject<Employed>();
  final _stateSelected = BehaviorSubject<String>();
  final _warehousesAvailable = BehaviorSubject<List<Warehouse>>();
  final _branchesAvailable = BehaviorSubject<List<Branch>>();
  final _travelAvailable = BehaviorSubject<List<Warehouse>>();
  final _dateFrom = BehaviorSubject<DateTime>();
  final _dateTo = BehaviorSubject<DateTime>();
  final _state = BehaviorSubject<String>();
  final _observation = BehaviorSubject<String>();
  final _providerName = BehaviorSubject<String>();
  final _orders = BehaviorSubject<List<Order>>();
  final _message = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>();
  final _access = BehaviorSubject<AccessByRole>();
  final OrdersRepository _ordersRepository = OrdersRepository();

  /// Observables
  ValueObservable<User> get userLogged => _user.stream;

  ValueObservable<String> get id => _id.stream;

  Observable<Warehouse> get warehouseSelected => _warehouseSelected.stream;

  Observable<Branch> get branchSelected => _branchSelected.stream;

  Observable<Warehouse> get travelSelected => _travelSelected.stream;

  Observable<Employed> get applicantSelected => _applicantSelected.stream;

  Observable<String> get stateSelected => _stateSelected.stream;

  Observable<List<Warehouse>> get warehousesAvailable =>
      _warehousesAvailable.stream;

  Observable<List<Branch>> get branchesAvailable => _branchesAvailable.stream;

  ValueObservable<DateTime> get dateFrom => _dateFrom.stream;

  ValueObservable<DateTime> get dateTo => _dateTo.stream;

  Observable<List<Order>> get orders => _orders.stream;

  ValueObservable<String> get state => _state.stream;

  ValueObservable<String> get observation => _observation.stream;

  ValueObservable<String> get provider => _providerName.stream;

  Observable<bool> get loading => _loading.stream;

  Observable<AccessByRole> get access => _access.stream;

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

  Stream<List<Warehouse>> get travels => _travelSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchTravels(terms);
      });

  Stream<List<Employed>> get employees => _applicantSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchEmployees(terms);
      });

  Future<void> fetchOrders() async {
    _orders.sink.add(null);
    _loading.sink.add(true);
    await _ordersRepository
        .fetchOrders(
            _id.value != null ? int.parse(_id.value) : 0,
            _warehouseSelected.value,
            _branchSelected.value,
            _travelSelected.value,
            _applicantSelected.value,
            _dateFrom.value,
            _dateTo.value,
            _state.value,
            _observation.value,
            _providerName.value)
        .timeout(Duration(seconds: 30))
        .then((data) {
      _orders.sink.add(data);
      _loading.sink.add(false);
    }).catchError((error) {
      _message.sink.add('Error: ${error.toString()}');
      _loading.sink.add(false);
    });
  }

  Function(User) get changeUser => _user.add;

  Function(String) get changeWarehouseSearch => _warehouseSearch.add;

  Function(String) get changeBranchSearch => _branchSearch.add;

  Function(String) get changeTravelSearch => _travelSearch.add;

  Function(DateTime) get changeDateFrom => _dateFrom.add;

  Function(DateTime) get changeDateTo => _dateTo.add;

  Function(Warehouse) get changeWarehouseSelected => _warehouseSelected.add;

  Function(Branch) get changeBranchSelected => _branchSelected.add;

  Function(Warehouse) get changeTravelSelected => _travelSelected.add;

  Function(String) get changeApplicantSearch => _applicantSearch.add;

  Function(Employed) get changeApplicantSelected => _applicantSelected.add;

  Function(String) get changeState => _state.add;

  Function(String) get changeObservation => _observation.add;

  Function(String) get changeProvider => _providerName.add;

  Function(AccessByRole) get changeAccess => _access.add;

  void changeId(String id) {
    _id.sink.add(id);
  }

  void cleanFilters() {
    _observation.sink.add('');
    _warehouseSelected.sink.add(null);
    _branchSelected.sink.add(null);
    _travelSelected.sink.add(null);
    _applicantSelected.sink.add(null);
    _dateFrom.sink.add(DateTime.now());
    _dateTo.sink.add(DateTime.now());
    _state.sink.add('');
    _observation.sink.add('');
    _providerName.sink.add('');
  }

  void addNewOrderToList(Order order) {
    List<Order> orders = _orders.value;
    orders.add(order);
    _orders.sink.add(orders);
  }

  void updateOrderInList(Order order) {
    List<Order> orders = _orders.value;
    int index = orders.indexWhere((o) => o.id == order.id);
    orders.removeAt(index);
    orders.insert(index, order);
  }

  @override
  void dispose() {
    _user.close();
    _id.close();
    _warehouseSearch.close();
    _warehouseSelected.close();
    _branchSearch.close();
    _branchSelected.close();
    _travelSearch.close();
    _travelSelected.close();
    _applicantSearch.close();
    _applicantSelected.close();
    _stateSelected.close();
    _warehousesAvailable.close();
    _branchesAvailable.close();
    _travelAvailable.close();
    _dateFrom.close();
    _dateTo.close();
    _state.close();
    _observation.close();
    _providerName.close();
    _orders.close();
    _message.close();
    _loading.close();
    _access.close();
  }
}

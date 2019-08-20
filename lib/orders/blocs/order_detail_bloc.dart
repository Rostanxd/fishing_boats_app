import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/orders/resources/orders_repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc extends BlocBase {
  final _user = BehaviorSubject<User>();
  final _id = BehaviorSubject<int>();
  final _date = BehaviorSubject<DateTime>();
  final _warehouseSelected = BehaviorSubject<Warehouse>();
  final _branchSelected = BehaviorSubject<Branch>();
  final _applicantSelected = BehaviorSubject<Employed>();
  final _travelSelected = BehaviorSubject<Warehouse>();
  final _state = BehaviorSubject<String>();
  final _observation = BehaviorSubject<String>();
  final _providerName = BehaviorSubject<String>();
  final _userCreated = BehaviorSubject<String>();
  final _dateCreated = BehaviorSubject<DateTime>();
  final _orderDetail = BehaviorSubject<List<OrderDetail>>();
  final _activeForm = BehaviorSubject<bool>();
  final _detailQuantity = BehaviorSubject<int>();
  final _detailDescription = BehaviorSubject<String>();
  final _warehouses = BehaviorSubject<List<Warehouse>>();
  final _branches = BehaviorSubject<List<Branch>>();
  final _travels = BehaviorSubject<List<Warehouse>>();
  final _warehouseSearch = BehaviorSubject<String>();
  final _branchSearch = BehaviorSubject<String>();
  final _travelSearch = BehaviorSubject<String>();
  final _employedSearch = BehaviorSubject<String>();
  final _message = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>();
  final OrdersRepository _ordersRepository = OrdersRepository();

  ValueObservable<User> get userLogged => _user.stream;

  Observable<int> get id => _id.stream;

  ValueObservable<DateTime> get date => _date.stream;

  Observable<Warehouse> get warehouse => _warehouseSelected.stream;

  Observable<Branch> get branch => _branchSelected.stream;

  Observable<Warehouse> get travel => _travelSelected.stream;

  Observable<Employed> get applicant => _applicantSelected.stream;

  Observable<String> get state => _state.stream;

  Observable<String> get observation => _observation.stream;

  Observable<String> get providerName => _providerName.stream;

  Observable<String> get userCreated => _userCreated.stream;

  Observable<DateTime> get dateCreated => _dateCreated.stream;

  Observable<List<OrderDetail>> get orderDetail => _orderDetail.stream;

  Observable<bool> get activeForm => _activeForm.stream;

  Observable<int> get detailQuantity => _detailQuantity.stream;

  Observable<String> get detailDescription => _detailDescription.stream;

  Observable<String> get messenger => _message.stream;

  Observable<String> get warehouseSearch => _warehouseSearch.stream;

  Observable<String> get branchSearch => _branchSearch.stream;

  Observable<String> get travelSearch => _travelSearch.stream;

  Observable<bool> get loading => _loading.stream;

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

  Stream<List<Employed>> get employees => _employedSearch
          .debounce(const Duration(milliseconds: 500))
          .switchMap((terms) async* {
        yield await _ordersRepository.fetchEmployees(terms);
      });

  Function(User) get changeUser => _user.add;

  Function(int) get changeId => _id.add;

  Function(DateTime) get changeDate => _date.add;

  Function(Warehouse) get changeWarehouse => _warehouseSelected.add;

  Function(Branch) get changeBranch => _branchSelected.add;

  Function(Warehouse) get changeTravel => _travelSelected.add;

  Function(Employed) get changeApplicant => _applicantSelected.add;

  Function(String) get changeState => _state.add;

  Function(String) get changeObservation => _observation.add;

  Function(String) get changeProviderName => _providerName.add;

  Function(String) get changeUserCreated => _userCreated.add;

  Function(DateTime) get changeDateCreated => _dateCreated.add;

  Function(bool) get changeActiveForm => _activeForm.add;

  Function(int) get changeDetailQuantity => _detailQuantity.add;

  Function(String) get changeDetailDescription => _detailDescription.add;

  Function(String) get changeMessenger => _message.add;

  Function(String) get changeWarehouseSearch => _warehouseSearch.add;

  Function(String) get changeBranchSearch => _branchSearch.add;

  Function(String) get changeTravelSearch => _travelSearch.add;

  Function(String) get changeEmployedSearch => _employedSearch.add;

  void loadStreamData(Order _order) {
    if (_order != null) {
      _id.sink.add(_order.id);
      _date.sink.add(_order.date);
      _warehouseSelected.sink.add(_order.warehouse);
      _branchSelected.sink.add(_order.branch);
      _travelSelected.sink.add(_order.travel);
      _applicantSelected.sink.add(_order.applicant);
      _state.sink.add(_order.state);
      _observation.sink.add(_order.observation);
      _providerName.sink.add(_order.providerName);
      _orderDetail.sink.add(_order.detail);
      _activeForm.sink.add(false);
    } else {
      _state.sink.add('');
      _date.sink.add(DateTime.now());
      _activeForm.sink.add(true);
    }
  }

  /// ORDER HEADER LOGIC

  /// ORDER DETAIL LOGIC
  void addRemoveQuantityDetail(bool adding) {
    if (adding) {
      _detailQuantity.sink.add(_detailQuantity.value + 1);
    } else {
      if (_detailQuantity.value > 0)
        _detailQuantity.sink.add(_detailQuantity.value - 1);
    }
  }

  Future<bool> updateDetailLine(int index) async {
    if (_detailDescription.value == '' || _detailQuantity.value == 0) {
      _message.sink.add(
          'No ha especificado cantidad y el detalle. Verifique por favor.');
      return false;
    }

    List<OrderDetail> _orderDetailToUpd = _orderDetail.value;
    if (_orderDetailToUpd.length != 0) {
      _orderDetailToUpd[index].quantity = _detailQuantity.value;
      _orderDetailToUpd[index].detail = _detailDescription.value;
      _orderDetail.sink.add(_orderDetailToUpd);
    }
    return true;
  }

  void removeDetailLine(int index) {
    List<OrderDetail> _orderDetailToUpd = _orderDetail.value;
    if (_orderDetailToUpd.length != 0) {
      _orderDetailToUpd.removeAt(index);
      _orderDetail.sink.add(_orderDetailToUpd);
    }
  }

  Future<bool> addNewDetailLine() async {
    if (_detailDescription.value == '' || _detailQuantity.value == 0) {
      _message.sink.add(
          'No ha especificado la cantidad y/o el detalle. Verifique por favor.');
      return false;
    }

    List<OrderDetail> _orderDetailToUpd = List<OrderDetail>();
    if (_orderDetail.value != null) _orderDetailToUpd = _orderDetail.value;

    _orderDetailToUpd
        .add(OrderDetail(0, _detailQuantity.value, _detailDescription.value));
    _orderDetail.sink.add(_orderDetailToUpd);
    return true;
  }

  Future<Order> createOrder() async {
    _loading.sink.add(true);
    Order _order = Order(
        0,
        _date.value,
        'P',
        _observation.value,
        _warehouseSelected.value,
        _branchSelected.value,
        _applicantSelected.value,
        _travelSelected.value,
        '',
        _user.value.user,
        DateTime.now(),
        null,
        _orderDetail.value);
    await _ordersRepository.createOrder(_order).then((value) {
      _order.id = value;
      _id.sink.add(value);
      _state.sink.add('P');
      _message.sink.add('Orden genearada con éxito.');
      _loading.sink.add(false);
    }, onError: (error) {
      _message.sink.add('Error: ${error.toString()}');
      _loading.sink.add(false);
    });

    return _order;
  }

  Future<Order> updatingOrder(String stateToUpd) async {
    String message;
    _loading.sink.add(true);

    Order _order = Order(
        _id.value,
        _date.value,
        stateToUpd,
        _observation.value,
        _warehouseSelected.value,
        _branchSelected.value,
        _applicantSelected.value,
        _travelSelected.value,
        '',
        _user.value.user,
        DateTime.now(),
        stateToUpd == 'A' ? DateTime.now() : null,
        _orderDetail.value);

    await _ordersRepository.updateOrder(_order).then((value) {
      switch (stateToUpd) {
        case "P":
          message = 'Orden actualizada con éxito';
          break;
        case "A":
          message = 'Orden procesada con éxito';
          break;
        case "X":
          message = 'Orden anulada con éxito';
          break;
      }
      _state.sink.add(stateToUpd);
      _message.sink.add(message);
      _loading.sink.add(false);
    }, onError: (error) {
      _message.sink.add('Error: ${error.toString()}');
      _loading.sink.add(false);
    }).timeout(Duration(seconds: 15));

    return _order;
  }

  @override
  void dispose() {
    _user.close();
    _id.close();
    _date.close();
    _warehouseSelected.close();
    _branchSelected.close();
    _applicantSelected.close();
    _travelSelected.close();
    _state.close();
    _observation.close();
    _providerName.close();
    _userCreated.close();
    _dateCreated.close();
    _orderDetail.close();
    _activeForm.close();
    _detailQuantity.close();
    _detailDescription.close();
    _message.close();
    _warehouses.close();
    _branches.close();
    _travels.close();
    _warehouseSearch.close();
    _branchSearch.close();
    _travelSearch.close();
    _loading.close();
  }
}

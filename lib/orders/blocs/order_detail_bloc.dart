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
  final _order = BehaviorSubject<Order>();
  final _id = BehaviorSubject<int>();
  final _date = BehaviorSubject<DateTime>();
  final _warehouseSelected = BehaviorSubject<Warehouse>();
  final _branchSelected = BehaviorSubject<Branch>();
  final _applicantSelected = BehaviorSubject<Employed>();
  final _travelSelected = BehaviorSubject<Warehouse>();
  final _state = BehaviorSubject<String>();
  final _observation = BehaviorSubject<String>();
  final _commentary = BehaviorSubject<String>();
  final _providerName = BehaviorSubject<String>();
  final _userCreated = BehaviorSubject<String>();
  final _dateCreated = BehaviorSubject<DateTime>();
  final _orderDetail = BehaviorSubject<List<OrderDetail>>();
  final _activeForm = BehaviorSubject<bool>();
  final _detailQuantity = BehaviorSubject<double>();
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

  Observable<Order> get order => _order.stream;

  Observable<int> get id => _id.stream;

  ValueObservable<DateTime> get date => _date.stream;

  Observable<Warehouse> get warehouse => _warehouseSelected.stream;

  Observable<Branch> get branch => _branchSelected.stream;

  Observable<Warehouse> get travel => _travelSelected.stream;

  Observable<Employed> get applicant => _applicantSelected.stream;

  Observable<String> get state => _state.stream;

  Observable<String> get observation => _observation.stream;

  ValueObservable<String> get commentary => _commentary.stream;

  Observable<String> get providerName => _providerName.stream;

  Observable<String> get userCreated => _userCreated.stream;

  Observable<DateTime> get dateCreated => _dateCreated.stream;

  Observable<List<OrderDetail>> get orderDetail => _orderDetail.stream;

  Observable<bool> get activeForm => _activeForm.stream;

  Observable<double> get detailQuantity => _detailQuantity.stream;

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

  Function(String) get changeCommentary => _commentary.add;

  Function(String) get changeProviderName => _providerName.add;

  Function(String) get changeUserCreated => _userCreated.add;

  Function(DateTime) get changeDateCreated => _dateCreated.add;

  Function(bool) get changeActiveForm => _activeForm.add;

  Function(String) get changeDetailDescription => _detailDescription.add;

  Function(String) get changeMessenger => _message.add;

  Function(String) get changeWarehouseSearch => _warehouseSearch.add;

  Function(String) get changeBranchSearch => _branchSearch.add;

  Function(String) get changeTravelSearch => _travelSearch.add;

  Function(String) get changeEmployedSearch => _employedSearch.add;

  void changeDetailQuantity(String quantityStr) {
    if (quantityStr.isNotEmpty)
      return _detailQuantity.sink.add(double.parse(quantityStr));
    _detailQuantity.sink.add(0.0);
  }

  void loadStreamData(Order order) {
    if (order != null) {
      _order.sink.add(order);
      _id.sink.add(order.id);
      _date.sink.add(order.date);
      _warehouseSelected.sink.add(order.warehouse);
      _branchSelected.sink.add(order.branch);
      _travelSelected.sink.add(order.travel);
      _applicantSelected.sink.add(order.applicant);
      _state.sink.add(order.state);
      _observation.sink.add(order.observation);
      _commentary.sink.add(order.commentary);
      _providerName.sink.add(order.providerName);
      _orderDetail.sink.add(order.detail);
      _activeForm.sink.add(false);
    } else {
      _order.sink.add(null);
      _state.sink.add('');
      _date.sink.add(DateTime.now());
      _activeForm.sink.add(true);
    }
  }

  /// LOGIC
  void addRemoveQuantityDetail(bool adding) {
    if (adding) {
      _detailQuantity.sink.add(_detailQuantity.value + 0.10);
    } else {
      if (_detailQuantity.value > 0)
        _detailQuantity.sink.add(_detailQuantity.value - 0.10);
    }
  }

  Future<bool> updateDetailLine(int index) async {
    if (_detailDescription.value == '' || _detailQuantity.value == 0) {
      _message.sink.add(
          'No ha especificado cantidad y/o el detalle. Verifique por favor.');
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
    if (!_validateForm()) {
      return null;
    }

    _loading.sink.add(true);
    Order order = Order(
        0,
        _date.value,
        'A',
        _observation.value,
        '',
        _warehouseSelected.value,
        _branchSelected.value,
        _applicantSelected.value,
        _travelSelected.value,
        '',
        _user.value.user,
        DateTime.now(),
        null,
        _orderDetail.value);
    await _ordersRepository.createOrder(order).then((value) {
      order.id = value;
      _order.sink.add(order);
      _id.sink.add(value);
      _state.sink.add('A');
      _message.sink.add('Orden generada con éxito.');
      _loading.sink.add(false);
    }, onError: (error) {
      _message.sink.add(error.toString());
      _loading.sink.add(false);
      order = null;
    });
    return order;
  }

  Future<Order> updatingOrder(String stateToUpd) async {
    if (!_validateForm()) {
      return null;
    }

    if (stateToUpd == 'P' &&
        (_commentary.value == null || _commentary.value == '')) {
      _message.sink.add('Error: Falta llenar el comentario de aprobación.');
      return null;
    }

    String message;
    _loading.sink.add(true);

    Order order = Order(
        _id.value,
        _date.value,
        stateToUpd,
        _observation.value,
        _commentary.value,
        _warehouseSelected.value,
        _branchSelected.value,
        _applicantSelected.value,
        _travelSelected.value,
        '',
        _user.value.user,
        DateTime.now(),
        stateToUpd == 'P' ? DateTime.now() : null,
        _orderDetail.value);

    await _ordersRepository.updateOrder(order).then((value) {
      switch (stateToUpd) {
        case "A":
          message = 'Orden actualizada con éxito';
          break;
        case "P":
          message = 'Orden procesada con éxito';
          break;
        case "X":
          message = 'Orden anulada con éxito';
          break;
      }
      _order.sink.add(order);
      _state.sink.add(stateToUpd);
      _message.sink.add(message);
      _loading.sink.add(false);
    }, onError: (error) {
      _message.sink.add(error.toString());
      _loading.sink.add(false);
      order = null;
    }).timeout(Duration(seconds: 15));

    return order;
  }

  bool _validateForm() {
    if (_warehouseSelected.value == null) {
      _message.sink.add('Error, por favor ingrese la bodega');
      return false;
    }

    if (_branchSelected.value == null) {
      _message.sink.add('Error, por favor ingrese el barco.');
      return false;
    }

    if (_travelSelected.value == null) {
      _message.sink.add('Error, por favor ingrese el viaje');
      return false;
    }

    if (_applicantSelected.value == null) {
      _message.sink.add('Error, por favor ingrese el solicitante.');
      return false;
    }

    if (_observation.value == null || _observation.value == '') {
      _message.sink.add('Error, por favor ingrese la observación general.');
      return false;
    }

    if (_orderDetail.value == null || _orderDetail.value.length == 0) {
      _message.sink.add('Error, no ha ingresado el detalle de la orden.');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _user.close();
    _order.close();
    _id.close();
    _date.close();
    _warehouseSelected.close();
    _branchSelected.close();
    _applicantSelected.close();
    _travelSelected.close();
    _state.close();
    _observation.close();
    _commentary.close();
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

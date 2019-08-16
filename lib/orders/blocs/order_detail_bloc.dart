import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc extends BlocBase {
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

  Observable<int> get id => _id.stream;

  ValueObservable<DateTime> get date => _date.stream;

  Observable<Warehouse> get warehouse => _warehouseSelected.stream;

  Observable<Branch> get branch => _branchSelected.stream;

  Observable<Warehouse> get travel => _travelSelected.stream;

  Observable<String> get state => _state.stream;

  Observable<String> get observation => _observation.stream;

  Observable<String> get providerName => _providerName.stream;

  Observable<String> get userCreated => _userCreated.stream;

  Observable<DateTime> get dateCreated => _dateCreated.stream;

  Observable<List<OrderDetail>> get orderDetail => _orderDetail.stream;

  Observable<bool> get activeForm => _activeForm.stream;

  /// Functions
  Function(int) get changeId => _id.add;

  Function(DateTime) get changeDate => _date.add;

  Function(Warehouse) get changeWarehouse => _warehouseSelected.add;

  Function(Branch) get changeBranch => _branchSelected.add;

  Function(Warehouse) get changeTravel => _travelSelected.add;

  Function(String) get changeState => _state.add;

  Function(String) get changeObservation => _observation.add;

  Function(String) get changeProviderName => _providerName.add;

  Function(String) get changeUserCreated => _userCreated.add;

  Function(DateTime) get changeDateCreated => _dateCreated.add;

  Function(bool) get changeActiveForm => _activeForm.add;

  void loadStreamData (Order _order) {
    if (_order != null) {
      _id.sink.add(_order.id);
      _date.sink.add(_order.date);
      _warehouseSelected.sink.add(_order.warehouse);
      _branchSelected.sink.add(_order.branch);
      _travelSelected.sink.add(_order.travel);
      _state.sink.add(_order.state);
      _observation.sink.add(_order.observation);
      _providerName.sink.add(_order.providerName);
      _orderDetail.sink.add(_order.detail);
      _activeForm.sink.add(false);
    } else {
      _activeForm.sink.add(true);
    }
  }

  @override
  void dispose() {
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
  }

}
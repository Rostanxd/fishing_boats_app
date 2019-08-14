import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc extends BlocBase {
  final _id = BehaviorSubject<int>();
  final _date = BehaviorSubject<DateTime>();
  final _warehouseSelected = BehaviorSubject<Warehouse>();
  final _branchSelected = BehaviorSubject<Branch>();
  final _applicantSelected = BehaviorSubject<Employed>();
  final _state = BehaviorSubject<String>();
  final _observation = BehaviorSubject<String>();

  @override
  void dispose() {
    _id.close();
    _date.close();
    _warehouseSelected.close();
    _branchSelected.close();
    _applicantSelected.close();
    _state.close();
    _observation.close();
  }

}
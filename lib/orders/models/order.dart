import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';

import 'branch.dart';

class Order extends Object {
  int id;
  DateTime date;
  String state;
  String observation;
  Warehouse warehouse;
  Branch branch;
  Employed applicant;
  List<OrderDetail> detail;

  Order(this.id, this.date, this.state, this.observation, this.warehouse,
      this.branch, this.applicant, this.detail);

  Order.fromFishBackEndApiRest(Map<String, dynamic> jsonData) {
    Iterable detailIterable = Iterable.empty();

    this.id = jsonData['order_id'];
    this.date = DateTime.parse(jsonData['date']);
    this.state = jsonData['state'];
    this.observation = jsonData['observation'];
    this.warehouse = Warehouse.fromSimpleMap(
        {'code': jsonData['warehouse_id'], 'name': jsonData['warehouse_name']});
    this.branch = Branch.fromSimpleMap(
        {'code': jsonData['branch_id'], 'name': jsonData['branch_name']});
    this.applicant = Employed.fromSimpleMap({
      'id': jsonData['applicant_id'],
      'firstName': jsonData['applicant_name']
    });

    detailIterable = jsonData['detail'];
    if (detailIterable.length > 0) {
      this.detail =
          detailIterable.map((d) => OrderDetail.fromSimpleMap(d)).toList();
    } else {
      this.detail = [];
    }
  }

  @override
  String toString() {
    return 'Order{id: $id, date: $date, state: $state, '
        'observation: $observation, warehouse: $warehouse, applicant: $applicant}';
  }
}

class OrderDetail extends Object {
  int sequence;
  int quantity;
  String detail;

  OrderDetail(this.sequence, this.quantity, this.detail);

  OrderDetail.fromSimpleMap(Map<String, dynamic> json) {
    this.sequence = json['sequence'] != null ? json['sequence'] : 0;
    this.quantity = json['quantity'] != null ? json['quantity'] : 0;
    this.detail = json['detail'] != null ? json['detail'] : '';
  }

  @override
  String toString() {
    return 'OrderDetail{sequence: $sequence, quantity: $quantity, detail: $detail}';
  }
}

import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';

import 'branch.dart';

class Order extends Object {
  int id;
  DateTime date;
  String state;
  String observation;
  String commentary;
  Warehouse warehouse;
  Branch branch;
  Employed applicant;
  Warehouse travel;
  String providerName;
  String userCreated;
  DateTime dateCreated;
  DateTime dateApproved;
  List<OrderDetail> detail;

  Order(
      this.id,
      this.date,
      this.state,
      this.observation,
      this.commentary,
      this.warehouse,
      this.branch,
      this.applicant,
      this.travel,
      this.providerName,
      this.userCreated,
      this.dateCreated,
      this.dateApproved,
      this.detail);

  Order.fromFishBackEndApiRest(Map<String, dynamic> jsonData) {
    Iterable detailIterable = Iterable.empty();

    this.id = jsonData['order_id'];
    this.date = DateTime.parse(jsonData['date']);
    this.state = jsonData['state'];
    this.observation = jsonData['observation'];
    this.commentary =
        jsonData['commentary'] != null ? jsonData['commentary'] : '';
    this.warehouse = Warehouse.fromSimpleMap(
        {'code': jsonData['warehouse_id'], 'name': jsonData['warehouse_name']});
    this.branch = Branch.fromSimpleMap(
        {'code': jsonData['branch_id'], 'name': jsonData['branch_name']});
    this.applicant = Employed.fromSimpleMap({
      'id': jsonData['applicant_id'],
      'firstName': jsonData['applicant_name']
    });
    this.travel = Warehouse.fromSimpleMap(
        {'code': jsonData['travel_id'], 'name': jsonData['travel_name']});
    this.providerName =
        jsonData['provider_name'] != null ? jsonData['provider_name'] : '';
    this.userCreated = jsonData['user_created'];
    this.dateCreated = DateTime.parse(jsonData['date_created']);
    this.dateApproved = jsonData['date_created'] != null
        ? DateTime.parse(jsonData['date_created'])
        : null;

    detailIterable = jsonData['detail'];
    if (detailIterable.length > 0) {
      this.detail =
          detailIterable.map((d) => OrderDetail.fromSimpleMap(d)).toList();
    } else {
      this.detail = [];
    }
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'date': this.date.toString(),
        'observation': this.observation,
        'commentary': this.commentary,
        'state': this.state,
        'warehouse': this.warehouse.toJson(),
        'branch': this.branch.toJson(),
        'travel': this.travel.toJson(),
        'applicant': this.applicant.toJson(),
        'providerName': this.providerName,
        'userCreated': this.userCreated,
        'dateCreated': this.dateCreated.toString(),
        'dateApproved':
            this.dateApproved != null ? this.dateApproved.toString() : '',
        'detail': this.detail.map((line) => line.toJson()).toList(),
      };

  @override
  String toString() {
    return 'Order{id: $id, date: $date, state: $state, '
        'observation: $observation, commentary: $commentary, warehouse: $warehouse, '
        'branch: $branch, applicant: $applicant, travel: $travel, '
        'providerName: $providerName, detail: $detail}';
  }
}

class OrderDetail extends Object {
  int sequence;
  double quantity;
  String detail;

  OrderDetail(this.sequence, this.quantity, this.detail);

  OrderDetail.fromSimpleMap(Map<String, dynamic> json) {
    this.sequence = json['sequence'] != null ? json['sequence'] : 0;
    this.quantity = json['quantity'] != null
        ? double.parse(json['quantity'].toString())
        : 0.0;
    this.detail = json['detail'] != null ? json['detail'] : '';
  }

  Map<String, dynamic> toJson() => {
        'sequence': this.sequence.toString(),
        'quantity': this.quantity.toString(),
        'detail': this.detail,
      };

  @override
  String toString() {
    return 'OrderDetail{sequence: $sequence, quantity: $quantity, detail: $detail}';
  }
}

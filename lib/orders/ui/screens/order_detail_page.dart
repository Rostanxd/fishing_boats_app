import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/orders/blocs/order_detail_bloc.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderDetailBloc _orderDetailBloc = OrderDetailBloc();
  final DateTime _now = new DateTime.now();
  final DateTime _defaultDate = DateTime.now();
  final TextEditingController _observationCtrl = TextEditingController();
  final formatter = new DateFormat('yyyy-MM-dd');

  AuthenticationBloc _authenticationBloc;
  Order _order;

  ///  Future to show the date picker
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _orderDetailBloc.date.value.toString().isNotEmpty &&
                _orderDetailBloc.date.value != null
            ? _orderDetailBloc.date.value
            : _defaultDate,
        firstDate: DateTime(_now.year),
        lastDate: DateTime(_now.year + 1));

    if (picked != null) {
      _orderDetailBloc.changeDate(picked);
    }
  }

  @override
  void initState() {
    _order = widget.order;
    _orderDetailBloc.loadStreamData(_order);
    if (_order != null) _observationCtrl.text = _order.observation;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _order != null
            ? Text('Pedido #${_order.id}')
            : Text('Nuevo pedido'),
        backgroundColor:
            _order != null ? _evaluateOrderColor(_order.state) : Colors.grey,
      ),
      body: StreamBuilder(
          stream: _orderDetailBloc.activeForm,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.data != null && snapshot.data
                ? _editableForm()
                : _displayForm();
          }),
      persistentFooterButtons: _order != null
          ? _evaluateActionButtons(_order.state)
          : _evaluateActionButtons(''),
    );
  }

  _displayForm() {
    return ListView(
      children: <Widget>[
        /// Warehouse
        StreamBuilder(
          stream: _orderDetailBloc.warehouse,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? snapshot.data.name : '-- No asignada --'),
              subtitle: Text('Bodega'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// Branch
        StreamBuilder(
          stream: _orderDetailBloc.branch,
          builder: (BuildContext context, AsyncSnapshot<Branch> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? snapshot.data.name : '-- No asignado --'),
              subtitle: Text('Barco'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// Travel
        StreamBuilder(
          stream: _orderDetailBloc.travel,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData ? snapshot.data.name : '-- N/A --'),
              subtitle: Text('Viaje'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// Date
        StreamBuilder(
          stream: _orderDetailBloc.date,
          builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? formatter.format(snapshot.data) : 'N/A'),
              subtitle: Text('Fecha registro desde'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// State
        StreamBuilder(
          stream: _orderDetailBloc.state,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String stateName = "";
            switch (snapshot.data) {
              case 'P':
                stateName = 'Pendiente';
                break;
              case 'A':
                stateName = 'Pendiente';
                break;
              case 'X':
                stateName = 'Pendiente';
                break;
            }
            return ListTile(
              title: Text(stateName),
              subtitle: Text('Estado'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// Observation
        StreamBuilder(
          stream: _orderDetailBloc.observation,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData ? snapshot.data : ''),
              subtitle: Text('Observación'),
              onTap: () {},
            );
          },
        ),
        Divider(),

        /// Provider
        StreamBuilder(
          stream: _orderDetailBloc.providerName,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData && snapshot.data.isNotEmpty
                  ? snapshot.data
                  : '-- N/A --'),
              subtitle: Text('Proveedor'),
              onTap: () {},
            );
          },
        ),
        Divider(),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0),
              child: Text(
                'Detalle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Divider(),
        Container(
          height: 400,
          color: Colors.white,
          child: StreamBuilder(
              stream: _orderDetailBloc.orderDetail,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderDetail>> detailSnapshot) {
                return detailSnapshot.data != null &&
                        detailSnapshot.data.length != 0
                    ? ListView.separated(
                        itemCount: detailSnapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: detailSnapshot.data[index].detail != null &&
                                    detailSnapshot.data[index].detail.isNotEmpty
                                ? Text(detailSnapshot.data[index].detail)
                                : Text('N/A'),
                            subtitle: detailSnapshot.data[index].quantity !=
                                        null &&
                                    detailSnapshot.data[index].quantity != 0
                                ? Text(
                                    'Cantidad ${detailSnapshot.data[index].quantity.toString()}')
                                : Text('N/A'),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                      )
                    : Center(
                        child: Container(
                          child: Text('No hay detalle.'),
                        ),
                      );
              }),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }

  _editableForm() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: _orderDetailBloc.warehouse,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? snapshot.data.name : '-- Seleccione --'),
              subtitle: Text('Bodega'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {},
            );
          },
        ),
        Divider(),
        StreamBuilder(
          stream: _orderDetailBloc.branch,
          builder: (BuildContext context, AsyncSnapshot<Branch> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? snapshot.data.name : '-- Seleccione --'),
              subtitle: Text('Barco'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {},
            );
          },
        ),
        Divider(),
        StreamBuilder(
          stream: _orderDetailBloc.travel,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title:
                  Text(snapshot.hasData ? snapshot.data.name : '-- Todas --'),
              subtitle: Text('Viaje'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {},
            );
          },
        ),
        Divider(),
        StreamBuilder(
          stream: _orderDetailBloc.date,
          builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData
                  ? formatter.format(snapshot.data)
                  : 'Ninguno'),
              subtitle: Text('Fecha registro'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                _selectDate();
              },
            );
          },
        ),
        Divider(),
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0),
          child: Text('Observación'),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextField(
            controller: _observationCtrl,
            onChanged: _orderDetailBloc.changeObservation,
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0),
              child: Text(
                'Detalle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        Divider(),
        Container(
          height: 400,
          color: Colors.white,
          child: StreamBuilder(
              stream: _orderDetailBloc.orderDetail,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderDetail>> detailSnapshot) {
                return detailSnapshot.data != null &&
                        detailSnapshot.data.length != 0
                    ? ListView.separated(
                        itemCount: detailSnapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: detailSnapshot.data[index].detail != null &&
                                    detailSnapshot.data[index].detail.isNotEmpty
                                ? Text(detailSnapshot.data[index].detail)
                                : Text('N/A'),
                            subtitle: detailSnapshot.data[index].quantity !=
                                        null &&
                                    detailSnapshot.data[index].quantity != 0
                                ? Text(
                                    'Cantidad ${detailSnapshot.data[index].quantity.toString()}')
                                : Text('N/A'),
                            trailing: Icon(Icons.more_vert),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                      )
                    : Center(
                        child: Container(
                          child: Text('No hay detalle.'),
                        ),
                      );
              }),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }

  _evaluateOrderColor(String state) {
    if (state == 'P') return Colors.transparent;
    if (state == 'A') return Colors.blueAccent;
    if (state == 'X') return Colors.redAccent;
  }

  _evaluateActionButtons(String state) {
    switch (state) {

      /// New order
      case '':
        return [
          RaisedButton(
            color: Colors.grey,
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          RaisedButton(
            color: Colors.blueAccent,
            child: Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _orderDetailBloc.changeActiveForm(false);
            },
          ),
        ];

      /// Pending order
      case 'P':
        return [
          RaisedButton(
            color: Colors.grey,
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              'Anular',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
          StreamBuilder(
            stream: _orderDetailBloc.activeForm,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data != null && snapshot.data
                  ? RaisedButton(
                      color: Colors.blueAccent,
                      child: Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _orderDetailBloc.changeActiveForm(false);
                      },
                    )
                  : RaisedButton(
                      color: Colors.blueAccent,
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _orderDetailBloc.changeActiveForm(true);
                      },
                    );
            },
          ),
        ];

      /// Order approved
      case 'A':
        return [
          RaisedButton(
            color: Colors.grey,
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              'Anular',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ];

      /// Order canceled
      case 'X':
        return [
          RaisedButton(
            color: Colors.grey,
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          RaisedButton(
            color: Colors.blueAccent,
            child: Text(
              'Procesar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ];
    }
  }
}

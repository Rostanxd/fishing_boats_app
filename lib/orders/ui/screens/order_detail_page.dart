import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/orders/blocs/order_detail_bloc.dart';
import 'package:fishing_boats_app/orders/blocs/order_page_bloc.dart';
import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/employed.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_detail_line_page.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_process_page.dart';
import 'package:fishing_boats_app/utils/conversion_data_type.dart';
import 'package:fishing_boats_app/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final OrderPageBloc orderPageBloc;
  final Order order;

  const OrderDetailPage(
      {Key key, this.order, this.authenticationBloc, this.orderPageBloc})
      : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderDetailBloc _orderDetailBloc = OrderDetailBloc();
  final TextEditingController _observationCtrl = TextEditingController();
  final formatter = new DateFormat('yyyy-MM-dd');

  OrderPageBloc _orderPageBloc;
  Order _order;

  @override
  void initState() {
    _orderPageBloc = widget.orderPageBloc;
    _order = widget.order;
    _orderDetailBloc.loadStreamData(_order);
    _orderDetailBloc.changeUser(widget.authenticationBloc.userLogged.value);
    if (_order != null) _observationCtrl.text = _order.observation;
    _orderDetailBloc.changeMessenger(null);

    /// Control the message in the dialog
    _orderDetailBloc.messenger.listen((message) {
      if (message != null)
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pedido'),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _orderDetailBloc.order,
      builder: (BuildContext context, AsyncSnapshot<Order> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: CircularProgressIndicator(),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: StreamBuilder(
                  stream: _orderDetailBloc.id,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return snapshot.hasData
                        ? Text('Pedido #${snapshot.data.toString()}')
                        : Text('Nuevo pedido');
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.keyboard_hide),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                ],
                backgroundColor: _evaluateOrderColor(snapshot.data),
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 1.0),
                  child: StreamBuilder(
                      stream: _orderDetailBloc.loading,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return snapshot.data != null && snapshot.data
                            ? LinearProgressIndicator()
                            : Container(
                                child: null,
                              );
                      }),
                ),
              ),
              body: StreamBuilder(
                  stream: _orderDetailBloc.activeForm,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.data != null && snapshot.data
                        ? _editableForm()
                        : _displayForm();
                  }),
              persistentFooterButtons: _evaluateActionButtons(snapshot.data),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _orderDetailBloc.dispose();
    super.dispose();
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

        /// Applicant
        StreamBuilder(
          stream: _orderDetailBloc.applicant,
          builder: (BuildContext context, AsyncSnapshot<Employed> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData && snapshot.data != null
                  ? '${snapshot.data.lastName.trim()} ${snapshot.data.firstName.trim()}'
                  : '-- Todas --'),
              subtitle: Text('Solicitante'),
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
              subtitle: Text('Fecha registro'),
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
              case 'A':
                stateName = 'Pendiente';
                break;
              case 'P':
                stateName = 'Aprobado';
                break;
              case 'X':
                stateName = 'Anulado';
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

        /// Observation
        StreamBuilder(
          stream: _orderDetailBloc.commentary,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData ? snapshot.data : ''),
              subtitle: Text('Aprobación'),
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
                                    'Cantidad ${ConversionDataType.doubleQuantityToString(detailSnapshot.data[index].quantity)}')
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
        /// Warehouse
        StreamBuilder(
          stream: _orderDetailBloc.warehouse,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title: Text(
                  snapshot.hasData ? snapshot.data.name : '-- Seleccione --'),
              subtitle: Text('Bodega'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                showSearch(
                    context: context,
                    delegate: WarehouseSearch(_orderDetailBloc));
              },
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
                  snapshot.hasData ? snapshot.data.name : '-- Seleccione --'),
              subtitle: Text('Barco'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                showSearch(
                    context: context, delegate: BranchSearch(_orderDetailBloc));
              },
            );
          },
        ),
        Divider(),

        /// Travel
        StreamBuilder(
          stream: _orderDetailBloc.travel,
          builder: (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
            return ListTile(
              title:
                  Text(snapshot.hasData ? snapshot.data.name : '-- Todas --'),
              subtitle: Text('Viaje'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                showSearch(
                    context: context, delegate: TravelSearch(_orderDetailBloc));
              },
            );
          },
        ),
        Divider(),

        /// Applicant
        StreamBuilder(
          stream: _orderDetailBloc.applicant,
          builder: (BuildContext context, AsyncSnapshot<Employed> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData && snapshot.data != null
                  ? '${snapshot.data.lastName.trim()} ${snapshot.data.firstName.trim()}'
                  : '-- Todas --'),
              subtitle: Text('Solicitante'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                showSearch(
                    context: context,
                    delegate: EmployedSearch(_orderDetailBloc));
              },
            );
          },
        ),
        Divider(),

        /// Date
        StreamBuilder(
          stream: _orderDetailBloc.date,
          builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
            return ListTile(
              title: Text(snapshot.hasData
                  ? formatter.format(snapshot.data)
                  : 'Ninguno'),
              subtitle: Text('Fecha registro'),
//              trailing: Icon(Icons.navigate_next),
              onTap: () {
//                _selectDate();
              },
            );
          },
        ),
        Divider(),

        /// Observation
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0),
          child: Text('Observación'),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextField(
            minLines: 1,
            maxLines: 3,
            controller: _observationCtrl,
            onChanged: _orderDetailBloc.changeObservation,
          ),
        ),
        Divider(),

        /// Detail
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OrderDetailLinePage(
                                  orderDetailBloc: _orderDetailBloc,
                                  orderDetail: null,
                                  index: null,
                                )));
                  }),
            ),
          ],
        ),
        Divider(),

        /// Detail list
        Container(
          height: 300,
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
                          return Dismissible(
                            key: Key('${index.toString()}-'
                                '${detailSnapshot.data[index].detail}'),
                            child: ListTile(
                              leading: Icon(Icons.arrow_right),
                              title:
                                  detailSnapshot.data[index].detail != null &&
                                          detailSnapshot
                                              .data[index].detail.isNotEmpty
                                      ? Text(detailSnapshot.data[index].detail)
                                      : Text('N/A'),
                              subtitle: detailSnapshot.data[index].quantity !=
                                          null &&
                                      detailSnapshot.data[index].quantity != 0
                                  ? Text(
                                      'Cantidad ${ConversionDataType.doubleQuantityToString(detailSnapshot.data[index].quantity)}')
                                  : Text('N/A'),
                              trailing: Icon(Icons.more_vert),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OrderDetailLinePage(
                                              orderDetailBloc: _orderDetailBloc,
                                              orderDetail:
                                                  detailSnapshot.data[index],
                                              index: index,
                                            )));
                              },
                            ),
                            onDismissed: (direction) {
                              _orderDetailBloc.removeDetailLine(index);
                            },
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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

  _evaluateOrderColor(Order order) {
    if (order != null && order.state == 'A') return Colors.transparent;
    if (order != null && order.state == 'P') return Colors.green;
    if (order != null && order.state == 'X') return Colors.redAccent;
  }

  _evaluateActionButtons(Order order) {
    String state = '';
    if (order != null) state = order.state;

    switch (state) {

      /// New order
      case '':
        return [
          StreamBuilder<AccessByRole>(
              stream: _orderPageBloc.access,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data.register == '1'
                    ? RaisedButton(
                        color: Colors.blueAccent,
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _orderDetailBloc.createOrder().then((orderCreated) {
                            if (orderCreated != null) {
                              _orderDetailBloc.changeActiveForm(false);
                              _orderPageBloc.addNewOrderToList(orderCreated);
                            }
                          });
                        },
                      )
                    : RaisedButton(
                        color: Colors.grey,
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      );
              }),
        ];

      /// Pending order
      case 'A':
        return [
          StreamBuilder<AccessByRole>(
              stream: _orderPageBloc.access,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data.delete == '1'
                    ? RaisedButton(
                        color: Colors.redAccent,
                        child: Text(
                          'Anular',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _orderDetailBloc
                              .updatingOrder('X')
                              .then((orderUpdated) {
                            if (orderUpdated != null)
                              _orderPageBloc.updateOrderInList(orderUpdated);
                          });
                        },
                      )
                    : RaisedButton(
                        color: Colors.grey,
                        child: Text(
                          'Anular',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      );
              }),
          StreamBuilder(
            stream: _orderDetailBloc.activeForm,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data != null && snapshot.data
                  ? RaisedButton(
                      color: Colors.grey,
                      child: Text(
                        'Procesar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                  : StreamBuilder<AccessByRole>(
                      stream: _orderPageBloc.access,
                      builder: (BuildContext context,
                          AsyncSnapshot<AccessByRole> snapshot) {
                        return snapshot.hasData && snapshot.data.process == '1'
                            ? RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  'Procesar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrderProcessPage(
                                                orderPageBloc: _orderPageBloc,
                                                orderDetailBloc:
                                                    _orderDetailBloc,
                                              )));
                                },
                              )
                            : RaisedButton(
                                color: Colors.grey,
                                child: Text(
                                  'Procesar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              );
                      },
                    );
            },
          ),
          StreamBuilder(
            stream: _orderDetailBloc.activeForm,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data != null && snapshot.data
                  ? StreamBuilder<AccessByRole>(
                      stream: _orderPageBloc.access,
                      builder: (BuildContext context,
                          AsyncSnapshot<AccessByRole> snapshot) {
                        return snapshot.hasData && snapshot.data.register == '1'
                            ? RaisedButton(
                                color: Colors.blueAccent,
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _orderDetailBloc
                                      .updatingOrder('A')
                                      .then((orderUpdated) {
                                    if (orderUpdated != null) {
                                      _orderPageBloc
                                          .updateOrderInList(orderUpdated);
                                      _orderDetailBloc.changeActiveForm(false);
                                    }
                                  });
                                },
                              )
                            : RaisedButton(
                                color: Colors.grey,
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              );
                      },
                    )
                  : StreamBuilder<AccessByRole>(
                      stream: _orderPageBloc.access,
                      builder: (BuildContext context,
                          AsyncSnapshot<AccessByRole> snapshot) {
                        return snapshot.hasData &&
                                snapshot.data.edit == '1' &&
                                order.userCreated ==
                                    widget.authenticationBloc.userLogged.value
                                        .user
                            ? RaisedButton(
                                color: Colors.blueAccent,
                                child: Text(
                                  'Editar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _orderDetailBloc.changeActiveForm(true);
                                },
                              )
                            : RaisedButton(
                                color: Colors.grey,
                                child: Text(
                                  'Editar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              );
                      },
                    );
            },
          ),
        ];

      /// Order approved
      case 'P':
        return [
          StreamBuilder<AccessByRole>(
              stream: _orderPageBloc.access,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data.delete == '1'
                    ? RaisedButton(
                        color: Colors.redAccent,
                        child: Text(
                          'Anular',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _orderDetailBloc
                              .updatingOrder('X')
                              .then((orderUpdated) {
                            if (orderUpdated != null)
                              _orderPageBloc.updateOrderInList(orderUpdated);
                          });
                        },
                      )
                    : RaisedButton(
                        color: Colors.grey,
                        child: Text(
                          'Anular',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      );
              }),
        ];

      /// Order canceled
      case 'X':
        return [
          StreamBuilder<AccessByRole>(
              stream: _orderPageBloc.access,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data.process == '1'
                    ? RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'Procesar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderProcessPage(
                                        orderPageBloc: _orderPageBloc,
                                        orderDetailBloc: _orderDetailBloc,
                                      )));
                        },
                      )
                    : RaisedButton(
                        color: Colors.grey,
                        child: Text(
                          'Procesar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      );
              }),
        ];
    }
  }
}

class WarehouseSearch extends SearchDelegate<String> {
  final OrderDetailBloc _orderDetailBloc;

  WarehouseSearch(this._orderDetailBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _orderDetailBloc.warehouses,
      builder: (BuildContext context, AsyncSnapshot<List<Warehouse>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return centerCircularProgress();
          default:
            if (snapshot.hasError)
              return Container(
                child: Text(snapshot.error),
              );

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0)
              return Container(
                child: Text('Lo sentimos no existen coincidencias'),
              );

            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  trailing: Icon(Icons.check),
                  onTap: () {
                    _orderDetailBloc.changeWarehouse(snapshot.data[index]);
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre de la bodega a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderDetailBloc.changeWarehouseSearch(query);

      return StreamBuilder(
        stream: _orderDetailBloc.warehouses,
        builder:
            (BuildContext context, AsyncSnapshot<List<Warehouse>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return centerCircularProgress();
            default:
              if (snapshot.hasError)
                return Container(
                  child: Text(snapshot.error.toString()),
                );

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0)
                return Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text('Lo sentimos no existen coincidencias'),
                );

              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name),
                    trailing: Icon(Icons.check),
                    onTap: () {
                      _orderDetailBloc.changeWarehouse(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
          }
        },
      );
    }
  }
}

class BranchSearch extends SearchDelegate<String> {
  final OrderDetailBloc _orderDetailBloc;

  BranchSearch(this._orderDetailBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _orderDetailBloc.userLogged.value.role.code == '01'
          ? _orderDetailBloc.branches
          : _orderDetailBloc.branchesByUser,
      builder: (BuildContext context, AsyncSnapshot<List<Branch>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return centerCircularProgress();
          default:
            if (snapshot.hasError)
              return Container(
                child: Text(snapshot.error.toString()),
              );

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0)
              return Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text('Lo sentimos no existen coincidencias'),
              );

            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  trailing: Icon(Icons.check),
                  onTap: () {
                    _orderDetailBloc.changeBranch(snapshot.data[index]);
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty && _orderDetailBloc.userLogged.value.role.code == '01') {
      return ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre del barco a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderDetailBloc.changeBranchSearch(query);

      return StreamBuilder(
        stream: _orderDetailBloc.userLogged.value.role.code == '01'
            ? _orderDetailBloc.branches
            : _orderDetailBloc.branchesByUser,
        builder: (BuildContext context, AsyncSnapshot<List<Branch>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return centerCircularProgress();
            default:
              if (snapshot.hasError)
                return Container(
                  child: Text(snapshot.error.toString()),
                );

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0)
                return Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text('Lo sentimos no existen coincidencias'),
                );

              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name),
                    trailing: Icon(Icons.check),
                    onTap: () {
                      _orderDetailBloc.changeBranch(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
          }
        },
      );
    }
  }
}

class TravelSearch extends SearchDelegate<String> {
  final OrderDetailBloc _orderDetailBloc;

  TravelSearch(this._orderDetailBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _orderDetailBloc.travels,
      builder: (BuildContext context, AsyncSnapshot<List<Warehouse>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return centerCircularProgress();
          default:
            if (snapshot.hasError)
              return Container(
                child: Text(snapshot.error),
              );

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0)
              return Container(
                child: Text('Lo sentimos no existen coincidencias'),
              );

            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  trailing: Icon(Icons.check),
                  onTap: () {
                    _orderDetailBloc.changeTravel(snapshot.data[index]);
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre del viaje a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderDetailBloc.changeTravelSearch(query);

      return StreamBuilder(
        stream: _orderDetailBloc.travels,
        builder:
            (BuildContext context, AsyncSnapshot<List<Warehouse>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return centerCircularProgress();
            default:
              if (snapshot.hasError)
                return Container(
                  child: Text(snapshot.error.toString()),
                );

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0)
                return Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text('Lo sentimos no existen coincidencias'),
                );

              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name),
                    trailing: Icon(Icons.check),
                    onTap: () {
                      _orderDetailBloc.changeTravel(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
          }
        },
      );
    }
  }
}

class EmployedSearch extends SearchDelegate<String> {
  final OrderDetailBloc _orderDetailBloc;

  EmployedSearch(this._orderDetailBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _orderDetailBloc.employees,
      builder: (BuildContext context, AsyncSnapshot<List<Employed>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return centerCircularProgress();
          default:
            if (snapshot.hasError)
              return Container(
                child: Text(snapshot.error),
              );

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0)
              return Container(
                child: Text('Lo sentimos no existen coincidencias'),
              );

            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      '${snapshot.data[index].lastName} ${snapshot.data[index].firstName}'),
                  trailing: Icon(Icons.check),
                  onTap: () {
                    _orderDetailBloc.changeApplicant(snapshot.data[index]);
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre del solicitante a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderDetailBloc.changeEmployedSearch(query);

      return StreamBuilder(
        stream: _orderDetailBloc.employees,
        builder:
            (BuildContext context, AsyncSnapshot<List<Employed>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return centerCircularProgress();
            default:
              if (snapshot.hasError)
                return Container(
                  child: Text(snapshot.error.toString()),
                );

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0)
                return Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text('Lo sentimos no existen coincidencias'),
                );

              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        '${snapshot.data[index].lastName} ${snapshot.data[index].firstName}'),
                    trailing: Icon(Icons.check),
                    onTap: () {
                      _orderDetailBloc.changeApplicant(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
          }
        },
      );
    }
  }
}

import 'package:fishing_boats_app/orders/models/branch.dart';
import 'package:fishing_boats_app/orders/models/warehouse.dart';
import 'package:fishing_boats_app/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:fishing_boats_app/orders/blocs/order_page_bloc.dart';

import 'package:intl/intl.dart';

class OrderFilterPage extends StatefulWidget {
  final OrderPageBloc _orderPageBloc;

  OrderFilterPage(this._orderPageBloc);

  @override
  _OrderFilterPageState createState() => _OrderFilterPageState();
}

class _OrderFilterPageState extends State<OrderFilterPage> {
  OrderPageBloc _orderPageBloc;
  DateTime _fromDefaultDate = DateTime.now();
//  TextEditingController _fromDateCtrl = TextEditingController();
//  TextEditingController _toDateCtrl = TextEditingController();
  DateTime _now = new DateTime.now();
  final formatter = new DateFormat('yyyy-MM-dd');

  ///  Future to show the date picker
  Future _selectFromDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _orderPageBloc.dateFrom.value.toString().isNotEmpty &&
                _orderPageBloc.dateFrom.value != null
            ? _orderPageBloc.dateFrom.value
            : _fromDefaultDate,
        firstDate: DateTime(_now.year),
        lastDate: DateTime(_now.year + 1));

    if (picked != null) {
      _orderPageBloc.changeDateFrom(picked);
    }
  }

  ///  Future to show the date picker
  Future _selectToDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _orderPageBloc.dateTo.value.toString().isNotEmpty &&
                _orderPageBloc.dateTo.value != null
            ? _orderPageBloc.dateTo.value
            : _fromDefaultDate,
        firstDate: DateTime(_now.year),
        lastDate: DateTime(_now.year + 1));

    if (picked != null) {
      _orderPageBloc.changeDateTo(picked);
    }
  }

  @override
  void initState() {
    _orderPageBloc = widget._orderPageBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.restore_from_trash),
              onPressed: () {
                _orderPageBloc.cleanFilters();
              }),
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
                _orderPageBloc.fetchOrders();
              })
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            StreamBuilder(
              stream: _orderPageBloc.warehouseSelected,
              builder:
                  (BuildContext context, AsyncSnapshot<Warehouse> snapshot) {
                return ListTile(
                  title: Text(
                      snapshot.hasData ? snapshot.data.name : '-- Todas --'),
                  subtitle: Text('Bodega'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: WarehouseSearch(_orderPageBloc));
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder(
              stream: _orderPageBloc.branchSelected,
              builder: (BuildContext context, AsyncSnapshot<Branch> snapshot) {
                return ListTile(
                  title: Text(
                      snapshot.hasData ? snapshot.data.name : '-- Todos --'),
                  subtitle: Text('Barco'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: BranchSearch(_orderPageBloc));
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder(
              stream: _orderPageBloc.dateFrom,
              builder:
                  (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
                return ListTile(
                  title: Text(snapshot.hasData
                      ? formatter.format(snapshot.data)
                      : 'Ninguno'),
                  subtitle: Text('Fecha desde'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    _selectFromDate();
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder(
              stream: _orderPageBloc.dateTo,
              builder:
                  (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
                return ListTile(
                  title: Text(snapshot.hasData
                      ? formatter.format(snapshot.data)
                      : 'Ninguno'),
                  subtitle: Text('Fecha hasta'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    _selectToDate();
                  },
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class WarehouseSearch extends SearchDelegate<String> {
  final OrderPageBloc _orderPageBloc;

  WarehouseSearch(this._orderPageBloc);

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
      stream: _orderPageBloc.warehouses,
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
                    _orderPageBloc
                        .changeWarehouseSelected(snapshot.data[index]);
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
          ListTile(
            title: Text('-- Todas --'),
            trailing: Icon(Icons.check),
            onTap: () {
              _orderPageBloc.changeWarehouseSelected(null);
              Navigator.pop(context);
            },
          ),
          Divider(),
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre del barco a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderPageBloc.changeWarehouseSearch(query);

      return StreamBuilder(
        stream: _orderPageBloc.warehouses,
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
                      _orderPageBloc
                          .changeWarehouseSelected(snapshot.data[index]);
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
  final OrderPageBloc _orderPageBloc;

  BranchSearch(this._orderPageBloc);

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
      stream: _orderPageBloc.userLogged.value.role.code == '01'
          ? _orderPageBloc.branches
          : _orderPageBloc.branchesByUser,
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
                    _orderPageBloc.changeBranchSelected(snapshot.data[index]);
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
          ListTile(
            title: Text('-- Todos --'),
            trailing: Icon(Icons.check),
            onTap: () {
              _orderPageBloc.changeBranchSelected(null);
              Navigator.pop(context);
            },
          ),
          Divider(),
          Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Ingrese el nombre de la bodega a buscar.',
                style: TextStyle(fontSize: 16.0),
              ))
        ],
      );
    } else {
      _orderPageBloc.changeBranchSearch(query);

      return StreamBuilder(
        stream: _orderPageBloc.userLogged.value.role.code == '01'
            ? _orderPageBloc.branches
            : _orderPageBloc.branchesByUser,
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
                      _orderPageBloc.changeBranchSelected(snapshot.data[index]);
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

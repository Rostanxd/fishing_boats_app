import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/ui/widgets/user_drawer.dart';
import 'package:fishing_boats_app/orders/blocs/order_page_bloc.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_detail_page.dart';
import 'package:flutter/material.dart';

import 'order_filters_page.dart';

class OrderPage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final AccessByRole accessByRole;

  const OrderPage({Key key, this.authenticationBloc, this.accessByRole})
      : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  OrderPageBloc _orderPageBloc;

  @override
  void initState() {
    /// Add to the stream the current program
    widget.authenticationBloc
        .changeCurrentProgram(widget.accessByRole.program.code);

    _orderPageBloc = OrderPageBloc();
    _orderPageBloc.cleanFilters();
    _orderPageBloc.fetchOrders();
    _orderPageBloc.changeUser(widget.authenticationBloc.userLogged.value);
    _orderPageBloc.changeAccess(widget.accessByRole);
    _orderPageBloc.ordersLength.listen((data) {
      if (data != null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Se encontró ${data.toString()} coincidencia(s).'),
          duration: Duration(seconds: 3),
        ));
        _orderPageBloc.changeOrdersLength(null);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: UserDrawer(),
      appBar: AppBar(
        title: Text('Pedidos'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderFilterPage(_orderPageBloc)));
              })
        ],
        elevation: 5.0,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: StreamBuilder(
              stream: _orderPageBloc.loading,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.data != null && snapshot.data
                    ? LinearProgressIndicator()
                    : Container(
                        child: null,
                      );
              }),
        ),
      ),
      floatingActionButton: StreamBuilder<AccessByRole>(
          stream: _orderPageBloc.access,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data.register == '1'
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OrderDetailPage(
                                    authenticationBloc:
                                        widget.authenticationBloc,
                                    orderPageBloc: _orderPageBloc,
                                  )));
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blueAccent,
                  )
                : FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.grey,
                  );
          }),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _orderPageBloc.fetchOrders,
          child: StreamBuilder(
            stream: _orderPageBloc.orders,
            builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.hasError)
                return Container(
                  child: Text('Error: ${snapshot.error.toString()}'),
                );

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0)
                return Center(
                  child: Container(
                    child: Text('No hay resultados de la búsqueda.'),
                  ),
                );

              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: _evaluateOrderColor(snapshot.data[index].state),
                      child: ListTile(
                        leading: _evaluateOrder(snapshot.data[index].state),
                        title: Text('No. ${snapshot.data[index].id.toString()} - '
                            '${snapshot.data[index].branch.name}'),
                        subtitle: snapshot.data[index].observation.length > 35
                            ? Text(
                                '${snapshot.data[index].observation.substring(0, 30)}...')
                            : Text('${snapshot.data[index].observation}'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () {
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OrderDetailPage(
                                        authenticationBloc:
                                            widget.authenticationBloc,
                                        orderPageBloc: _orderPageBloc,
                                        order: snapshot.data[index],
                                      )));
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 2.0,
                    );
                  },
                  itemCount: snapshot.data.length);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderPageBloc.dispose();
    super.dispose();
  }


}

_evaluateOrder(String state) {
  if (state == 'A')
    return Icon(
      Icons.receipt,
      color: Colors.black,
    );
  if (state == 'P')
    return Icon(
      Icons.receipt,
      color: Colors.white,
    );
  if (state == 'X')
    return Icon(
      Icons.cancel,
      color: Colors.white,
    );
}

_evaluateOrderColor(String state) {
  if (state == 'A') return Colors.transparent;
  if (state == 'P') return Colors.green;
  if (state == 'X') return Colors.redAccent;
}

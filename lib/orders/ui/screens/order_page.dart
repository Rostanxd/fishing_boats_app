import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/orders/blocs/order_page_bloc.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_detail_page.dart';
import 'package:fishing_boats_app/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';

import 'order_filters_page.dart';

class OrderPage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const OrderPage({Key key, this.authenticationBloc}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderPageBloc _orderPageBloc;

  @override
  void initState() {
    _orderPageBloc = OrderPageBloc();
    _orderPageBloc.cleanFilters();
    _orderPageBloc.fetchOrders();
    _orderPageBloc.changeUser(widget.authenticationBloc.userLogged.value);
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
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderFilterPage(_orderPageBloc)));
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            OrderDetailPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          child: StreamBuilder(
            stream: _orderPageBloc.orders,
            builder:
                (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return centerCircularProgress();
                default:
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
                          color:
                              _evaluateOrderColor(snapshot.data[index].state),
                          child: ListTile(
                            leading: _evaluateOrder(snapshot.data[index].state),
                            title: Text(
                                'No. ${snapshot.data[index].id.toString()} - ${snapshot.data[index].branch.name}'),
                            subtitle: snapshot.data[index].observation.length >
                                    35
                                ? Text(
                                    '${snapshot.data[index].observation.substring(0, 30)}...')
                                : Text('${snapshot.data[index].observation}'),
                            trailing: Icon(Icons.navigate_next),
                            onTap: () {},
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(height: 2.0,);
                      },
                      itemCount: snapshot.data.length);
              }
            },
          ),
        ));
  }
}

_evaluateOrder(String state) {
  if (state == 'P')
    return Icon(
      Icons.receipt,
      color: Colors.black,
    );
  if (state == 'A')
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
  if (state == 'P') return Colors.transparent;
  if (state == 'A') return Colors.blueAccent;
  if (state == 'X') return Colors.redAccent;
}

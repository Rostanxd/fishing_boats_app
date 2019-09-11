import 'package:fishing_boats_app/orders/blocs/order_detail_bloc.dart';
import 'package:fishing_boats_app/orders/blocs/order_page_bloc.dart';
import 'package:flutter/material.dart';

class OrderProcessPage extends StatefulWidget {
  final OrderPageBloc orderPageBloc;
  final OrderDetailBloc orderDetailBloc;

  const OrderProcessPage({Key key, this.orderDetailBloc, this.orderPageBloc})
      : super(key: key);

  @override
  _OrderProcessPageState createState() => _OrderProcessPageState();
}

class _OrderProcessPageState extends State<OrderProcessPage> {
  OrderPageBloc _orderPageBloc;
  OrderDetailBloc _orderDetailBloc;
  TextEditingController _commentaryCtrl = TextEditingController();

  @override
  void initState() {
    _orderPageBloc = widget.orderPageBloc;
    _orderDetailBloc = widget.orderDetailBloc;
    _orderDetailBloc.changeMessenger(null);

    if (_orderDetailBloc.commentary != null)
      _commentaryCtrl.text = _orderDetailBloc.commentary.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprobación pedido'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_hide),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          /// Observation
          Container(
            margin: EdgeInsets.only(left: 15.0, top: 10.0),
            child: Text('Aprobación'),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              controller: _commentaryCtrl,
              onChanged: _orderDetailBloc.changeCommentary,
            ),
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          color: Colors.green,
          child: Text(
            'Procesar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _orderDetailBloc.updatingOrder('P').then((orderUpdated) {
              if (orderUpdated != null){
                _orderPageBloc.updateOrderInList(orderUpdated);

                //  Return to the order detail page
                Navigator.pop(context);
              }
            });
          },
        )
      ],
    );
  }
}

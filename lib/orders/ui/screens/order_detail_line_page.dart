import 'package:fishing_boats_app/orders/blocs/order_detail_bloc.dart';
import 'package:fishing_boats_app/orders/models/order.dart';
import 'package:flutter/material.dart';

class OrderDetailLinePage extends StatefulWidget {
  final OrderDetailBloc orderDetailBloc;
  final OrderDetail orderDetail;
  final int index;

  const OrderDetailLinePage(
      {Key key, this.orderDetail, this.orderDetailBloc, this.index})
      : super(key: key);

  @override
  _OrderDetailLinePageState createState() => _OrderDetailLinePageState();
}

class _OrderDetailLinePageState extends State<OrderDetailLinePage> {
  OrderDetailBloc _orderDetailBloc;
  OrderDetail _orderDetail;
  TextEditingController _descriptionCtrl = TextEditingController();

  @override
  void initState() {
    this._orderDetailBloc = widget.orderDetailBloc;
    this._orderDetail = widget.orderDetail;

    if (_orderDetail != null) {
      _orderDetailBloc.changeDetailQuantity(_orderDetail.quantity);
      _orderDetailBloc.changeDetailDescription(_orderDetail.detail);
      _descriptionCtrl.text = _orderDetail.detail;
    } else {
      _orderDetailBloc.changeDetailQuantity(0);
      _orderDetailBloc.changeDetailDescription('');
      _descriptionCtrl.text = '';
    }

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
        title: Text('Detalle pedido'),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder(
              stream: _orderDetailBloc.detailQuantity,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: 15.0, bottom: 5.0, top: 10.0),
                          child: snapshot.data != null
                              ? Text(snapshot.data.toString())
                              : Text('0'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15.0, bottom: 10.0),
                          child: Text('Cantidad'),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: IconButton(
                                onPressed: () {
                                  _orderDetailBloc
                                      .addRemoveQuantityDetail(false);
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: IconButton(
                                onPressed: () {
                                  _orderDetailBloc
                                      .addRemoveQuantityDetail(true);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }),
          Divider(
            height: 2,
          ),
          StreamBuilder(
              stream: _orderDetailBloc.detailDescription,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: TextField(
                    maxLines: 5,
                    onChanged: _orderDetailBloc.changeDetailDescription,
                    controller: _descriptionCtrl,
                  ),
                );
              })
        ],
      ),
      persistentFooterButtons: _footerButtons(widget.index),
    );
  }

  List<Widget> _footerButtons(int index) {
    if (index != null) {
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
          color: Colors.red,
          child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          onPressed: () {
            _orderDetailBloc.removeDetailLine(widget.index);
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          color: Colors.blueAccent,
          child: Text('Guardar', style: TextStyle(color: Colors.white)),
          onPressed: () {
            _orderDetailBloc.updateDetailLine(widget.index).then((value) {
              if (value) Navigator.pop(context);
            });
          },
        )
      ];
    } else {
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
          child: Text('Guardar', style: TextStyle(color: Colors.white)),
          onPressed: () {
            _orderDetailBloc.addNewDetailLine().then((value) {
              if (value) Navigator.pop(context);
            });
          },
        )
      ];
    }
  }
}

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
  TextEditingController _quantityCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();

  @override
  void initState() {
    this._orderDetailBloc = widget.orderDetailBloc;
    this._orderDetail = widget.orderDetail;

    if (_orderDetail != null) {
      _orderDetailBloc.changeDetailQuantity(_orderDetail.quantity.toString());
      _orderDetailBloc.changeDetailDescription(_orderDetail.detail);
      _quantityCtrl.text = _orderDetail.quantity.toString();
      _descriptionCtrl.text = _orderDetail.detail;
    } else {
      _orderDetailBloc.changeDetailQuantity('0.0');
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
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text('Cantidad'),
          ),
          StreamBuilder(
              stream: _orderDetailBloc.detailQuantity,
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                return Container(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    onChanged: _orderDetailBloc.changeDetailQuantity,
                    controller: _quantityCtrl,
                    keyboardType: TextInputType.number,
                  ),
                );
              }),
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Text('Detalle'),
          ),
          StreamBuilder(
              stream: _orderDetailBloc.detailDescription,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: TextField(
                    minLines: 1,
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

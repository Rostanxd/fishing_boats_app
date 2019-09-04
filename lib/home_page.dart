import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:flutter/material.dart';

import 'authentication/ui/widgets/user_drawer.dart';

class HomePage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const HomePage({Key key, this.authenticationBloc}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = widget.authenticationBloc;
    _authenticationBloc.changeCurrentProgram('000');
    /// Control the message in the dialog
    _authenticationBloc.messenger.listen((message) {
      if (message != null)
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('FiBo Pedidos'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      drawer: UserDrawer(),
      body: Container(
        child: null,
      ),
    );
  }
}

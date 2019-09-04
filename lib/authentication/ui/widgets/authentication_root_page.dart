import 'dart:io';

import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/ui/screens/login_page.dart';
import 'package:fishing_boats_app/home_page.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_page.dart';
import 'package:fishing_boats_app/router.dart';
import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';

class AuthenticationRootPage extends StatefulWidget {
  @override
  _AuthenticationRootPageState createState() => _AuthenticationRootPageState();
}

class _AuthenticationRootPageState extends State<AuthenticationRootPage> {
  AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.fetchDeviceInfo(Platform.isAndroid);
    _authenticationBloc.changeCurrentProgram('000');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationBloc.userLogged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _materialApp(Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ));
            break;
          default:
            if (snapshot.hasError) return _materialApp(_errorPage());
            if (snapshot.hasData && snapshot.data != null)
              return StreamBuilder(
                stream: _authenticationBloc.accessByRole,
                builder: (BuildContext context,
                    AsyncSnapshot<List<AccessByRole>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data[0].program.code == '001' &&
                      snapshot.data[0].execute == '1') {
                    return _materialApp(OrderPage(
                      authenticationBloc: _authenticationBloc,
                      accessByRole: snapshot.data[0],
                    ));
                  }
                  return _materialApp(HomePage(
                    authenticationBloc: _authenticationBloc,
                  ));
                },
              );
            return _materialApp(LoginPage());
        }
      },
    );
  }

  MaterialApp _materialApp(Widget widget) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fishing boats App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Router.generateRoute,
      home: widget,
    );
  }

  Widget _errorPage() {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0, left: 20.0),
              child: Text(
                "PEDIDOS",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 100.0),
                    child: Text('Error de conexión al servidor'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      child: Text(
                        'Re-intentar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _authenticationBloc.fetchDeviceInfo(Platform.isAndroid);
                      },
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/ui/screens/login_page.dart';
import 'package:fishing_boats_app/home_page.dart';
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fishing boats App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: _authenticationBloc.userLogged,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            default:
              if (snapshot.hasError) return _errorPage();
              if (snapshot.hasData && snapshot.data != null) return HomePage();
              return LoginPage();
          }
        },
      ),
    );
  }

  Widget _errorPage() {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 75.0, left: 20.0),
              child: Text(
                "PEDIDOS",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 150.0),
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

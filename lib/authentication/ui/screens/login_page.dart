import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.changeMessage(null);
    /// Control the message in the dialog
    _authenticationBloc.messenger.listen((message) {
      if (message != null)
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Inicio de sesión'),
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
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
              child: Container(
                height: 300.0,
                width: 300.0,
                margin: EdgeInsets.only(top: 75.0),
                child: Card(
                  elevation: 5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                          child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          _emailField(),
                          SizedBox(height: 20.0),
                          _passwordField(),
                          SizedBox(height: 50.0),
                          _streamButtonSubmit(),
                          SizedBox(height: 20.0),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Field for the user's Id
  Widget _emailField() {
    return StreamBuilder(
      stream: _authenticationBloc.user,
      builder: (context, snapshot) {
        return Container(
          width: 250.0,
          child: TextField(
            onChanged: _authenticationBloc.changeUser,
            decoration: InputDecoration(
                labelText: 'Usuario',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
                errorText: snapshot.error),
          ),
        );
      },
    );
  }

  /// Field for the user's password
  Widget _passwordField() {
    return StreamBuilder(
      stream: _authenticationBloc.password,
      builder: (context, snapshot) {
        return Container(
          width: 250.0,
          child: TextField(
            onChanged: _authenticationBloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Clave',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
                errorText: snapshot.error),
          ),
        );
      },
    );
  }

  /// Submit button for the form
  Widget _submitButton() {
    return StreamBuilder(
        stream: _authenticationBloc.validForm,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.hasData && snapshot.data != null && snapshot.data
              ? RaisedButton(
                  onPressed: () {
                    _authenticationBloc.logIn();
                  },
                  elevation: 5,
                  color: Colors.blueAccent,
                  child: Text(
                    'INGRESAR',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : RaisedButton(
                  onPressed: () {},
                  elevation: 5,
                  color: Colors.grey,
                  child: Text(
                    'INGRESAR',
                    style: TextStyle(color: Colors.white),
                  ),
                );
        });
  }

  /// Streamer to build button login or circular progress indicator
  Widget _streamButtonSubmit() {
    return StreamBuilder(
      stream: _authenticationBloc.logging,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return snapshot.hasData && snapshot.data
            ? Container(
                height: 40.0,
                color: Colors.transparent,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              )
            : _submitButton();
      },
    );
  }
}

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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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

    return StreamBuilder(
      stream: _authenticationBloc.userLogged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData ? HomePage() : LoginPage();
      },
    );
  }
}

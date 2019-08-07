import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final List<Widget> _listChildren = List<Widget>();

  AuthenticationBloc _authenticationBloc;

  User _user;

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _user = _authenticationBloc.userLogged.value;

    _loadDrawer(context);
    return Drawer(
      elevation: 5.0,
      child: ListView(children: _listChildren),
    );
  }

  Widget _header() {
    return DrawerHeader(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Text(
                    'Bienvenido',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                    height: 60.0,
                    width: 60.0,
                    margin: EdgeInsets.only(left: 10.0, right: 20.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/img/user.png')))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${_user.names.toUpperCase()}',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/img/fishing_boat_marine.jpg'))),
    );
  }

  void _loadDrawer(BuildContext context) {
    _listChildren.clear();

    /// Adding the header
    _listChildren.add(_header());

    _listChildren.add(ListTile(
      title: Text('Home'),
      leading: Icon(Icons.home),
      onTap: () {
        Navigator.pop(context);
      },
    ));

    _listChildren.add(ListTile(
      title: Text('Pedidos'),
      leading: Icon(Icons.receipt),
      onTap: () {
        Navigator.pop(context);
      },
    ));

    /// Adding options by the profile
    _listChildren.add(Divider());

    /// Adding exit option
    _listChildren.add(ListTile(
      title: Text('Salir'),
      leading: Icon(Icons.exit_to_app),
      onTap: () {
        /// Hidden the user drawer
        Navigator.pop(context);

        /// Calling the function to sign out
        _authenticationBloc.logOut();
      },
    ));

    _listChildren.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10.0),
          child: Text(
            'v0.1.0',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }
}

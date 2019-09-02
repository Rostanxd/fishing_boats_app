import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_page.dart';
import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
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

    return Drawer(
        elevation: 5.0,
        child: ListView(
          children: <Widget>[
            _header(),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            StreamBuilder(
              stream: _authenticationBloc.accessByRole,
              builder: (BuildContext context,
                  AsyncSnapshot<List<AccessByRole>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: LinearProgressIndicator(),
                    );
                    break;
                  default:
                    if (snapshot.hasData &&
                        snapshot.data[0].program.code == '001' &&
                        snapshot.data[0].execute == '1') {
                      return ListTile(
                        title: Text('Pedidos'),
                        leading: Icon(Icons.receipt),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPage(
                                        authenticationBloc: _authenticationBloc,
                                        accessByRole: snapshot.data[0],
                                      )));
                        },
                      );
                    }
                    return Container(
                      margin:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      child: Text('Usuario sin accesos.'),
                    );
                }
              },
            ),
            Divider(),
            ListTile(
              title: Text('Salir'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                /// Hidden the user drawer
                Navigator.pop(context);

                /// Calling the function to sign out
                _authenticationBloc.logOut();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text(
                    'v0.1.1',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
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
                    Container(
                      child: Text(
                        '${_user.role.name}',
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
}

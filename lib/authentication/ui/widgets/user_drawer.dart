import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/router.dart';
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

    return StreamBuilder(
      stream: _authenticationBloc.accessByRole,
      builder:
          (BuildContext context, AsyncSnapshot<List<AccessByRole>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _loadingDrawer();
            break;
          default:
            if (snapshot.hasError)
              return _messageDrawer(snapshot.error.toString());

            if (!snapshot.hasData)
              return _messageDrawer('No tiene accesos configurados');

            return _accessDrawer(snapshot.data);
        }
      },
    );
  }

  Drawer _accessDrawer(List<AccessByRole> accessList) {
    List<Widget> children = List<Widget>();
    children.add(_header());
    children.add(StreamBuilder(
        stream: _authenticationBloc.currentProgram,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return snapshot.hasData && snapshot.data == '000'
              ? ListTile(
                  title: Text('Home', style: TextStyle(color: Colors.grey)),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              : ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    ScreenArguments args =
                        ScreenArguments(_authenticationBloc, null);
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false,
                        arguments: args);
                  },
                );
        }));

    /// Adding the program with the access
    accessList.forEach((access) {
      children.add(StreamBuilder(
          stream: _authenticationBloc.currentProgram,
          builder: (BuildContext context, AsyncSnapshot<String> snapPrg) {
            if (snapPrg.hasData && snapPrg.data == access.program.code.trim())
              return ListTile(
                title: Text(
                  '${access.program.name}',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Icon(
                    IconData(access.program.icon, fontFamily: 'MaterialIcons')),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            if (access.execute != '1')
              return ListTile(
                title: Text(
                  '${access.program.name}',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Icon(
                    IconData(access.program.icon, fontFamily: 'MaterialIcons')),
                onTap: () {
                  Navigator.pop(context);
                  _authenticationBloc.changeMessage(
                      'Lo sentimos no tiene accesos a esta opción.');
                },
              );
            return ListTile(
              title: Text('${access.program.name}'),
              leading: Icon(
                  IconData(access.program.icon, fontFamily: 'MaterialIcons')),
              onTap: () {
                ScreenArguments args =
                    ScreenArguments(_authenticationBloc, access);
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    access.program.path.trim(), (Route<dynamic> route) => false,
                    arguments: args);
              },
            );
          }));
    });

    children.add(Divider());
    children.add(ListTile(
      title: Text('Salir'),
      leading: Icon(Icons.exit_to_app),
      onTap: () {
        /// Hidden the user drawer
        Navigator.pop(context);

        /// Calling the function to sign out
        _authenticationBloc.logOut();
      },
    ));
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10.0),
          child: Text(
            'v0.1.1',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));

    return Drawer(elevation: 5.0, child: ListView(children: children));
  }

  Drawer _messageDrawer(String message) {
    return Drawer(
        elevation: 5.0,
        child: ListView(
          children: <Widget>[
            _header(),
            StreamBuilder(
                stream: _authenticationBloc.currentProgram,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData && snapshot.data == '000'
                      ? ListTile(
                          title: Text('Home',
                              style: TextStyle(color: Colors.grey)),
                          leading: Icon(Icons.home),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      : ListTile(
                          title: Text('Home'),
                          leading: Icon(Icons.home),
                          onTap: () {
                            ScreenArguments args =
                                ScreenArguments(_authenticationBloc, null);
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false,
                                arguments: args);
                          },
                        );
                }),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(message),
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

  Drawer _loadingDrawer() {
    return Drawer(
        elevation: 5.0,
        child: ListView(
          children: <Widget>[
            _header(),
            StreamBuilder(
                stream: _authenticationBloc.currentProgram,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData && snapshot.data == '000'
                      ? ListTile(
                          title: Text('Home',
                              style: TextStyle(color: Colors.grey)),
                          leading: Icon(Icons.home),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      : ListTile(
                          title: Text('Home'),
                          leading: Icon(Icons.home),
                          onTap: () {
                            ScreenArguments args =
                                ScreenArguments(_authenticationBloc, null);
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false,
                                arguments: args);
                          },
                        );
                }),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: LinearProgressIndicator(),
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
                    'v0.1.4',
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

import 'package:fishing_boats_app/authentication/blocs/authentication_bloc.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/home_page.dart';
import 'package:fishing_boats_app/orders/ui/screens/order_page.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final ScreenArguments args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  authenticationBloc: args.authenticationBloc,
                ));
      case '/orders':
        return MaterialPageRoute(
            builder: (_) => OrderPage(
                  authenticationBloc: args.authenticationBloc,
                  accessByRole: args.accessByRole,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('Error: ruta no definida.')),
                ));
    }
  }
}

class ScreenArguments {
  final AuthenticationBloc authenticationBloc;
  final AccessByRole accessByRole;

  ScreenArguments(this.authenticationBloc, this.accessByRole);
}

import 'package:fishing_boats_app/widgets/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'authentication/blocs/authentication_bloc.dart';
import 'authentication/ui/widgets/authentication_root_page.dart';

void main() => runApp(BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To set-up vertical orientation (portrait).
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AuthenticationRootPage();
  }
}

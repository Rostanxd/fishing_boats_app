import 'package:flutter/material.dart';

import 'authentication/ui/widgets/user_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

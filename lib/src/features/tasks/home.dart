import 'package:flutter/cupertino.dart';

import '../bottom_nav_scaffold.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const BottomNavScaffold();
  }
}

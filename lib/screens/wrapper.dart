import 'package:crew_brew/screens/authenticate/authenticate.dart';
import 'package:crew_brew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crew_brew/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (user == null)
      return Authenticate();
    else
      return Home();
  }
}

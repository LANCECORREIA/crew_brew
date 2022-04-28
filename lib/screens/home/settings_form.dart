import 'package:crew_brew/models/user.dart';
import 'package:crew_brew/services/database.dart';
import 'package:crew_brew/shared/constants.dart';
import 'package:crew_brew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return StreamBuilder<UserData?>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _currentName = value;
                    },
                  ),
                  SizedBox(height: 20),
                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData!.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _currentSugars = value.toString();
                    },
                  ),
                  SizedBox(height: 20),

                  // slider
                  Slider(
                    value: (_currentStrength ?? userData!.strength ?? 100)
                        .toDouble(),
                    activeColor: Colors
                        .brown[_currentStrength ?? userData!.strength ?? 100],
                    inactiveColor: Colors
                        .brown[_currentStrength ?? userData!.strength ?? 100],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (value) {
                      setState(() {
                        _currentStrength = value.round();
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink[400],
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      print(_currentName);
                      print(_currentStrength);
                      print(_currentSugars);

                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData!.sugars ?? '0',
                          _currentName ?? userData!.name ?? '',
                          _currentStrength ?? userData!.strength ?? 100,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          }
          return Loading();
        });
  }
}

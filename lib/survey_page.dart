import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);

    return Container(
      padding: EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  appState.setUserAge(int.parse(value!));
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select your gender',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
                onSaved: (value) {
                  appState.setUserGender(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(
                          'Age: ${appState.userAge}, Gender: ${appState.userGender}');
                      // estimate MHR using Fairbarn method
                      if (appState.userGender == 'Male') {
                        appState.mhr = (201 - (0.8 * appState.userAge)).toInt();
                      } else if (appState.userGender == 'Female') {
                        appState.mhr = (226 - (1 * appState.userAge)).toInt();
                      } else {
                        appState.mhr = 0;
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 80),
              HRmax(),
            ],
          ),
        ),
      ),
    );
  }
}

class HRmax extends StatelessWidget {
  const HRmax({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var appState = Provider.of<MyAppState>(context, listen: true);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'HR', style: style),
              TextSpan(
                text: 'max',
                style: style.copyWith(
                    fontSize: theme.textTheme.displayMedium!.fontSize! * 0.4),
              ),
              TextSpan(text: ': ${appState.mhr}', style: style),
            ],
          ),
        ),
      ),
    );
  }
}

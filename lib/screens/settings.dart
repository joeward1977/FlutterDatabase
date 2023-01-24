import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterdatabase/models/coach.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  SettingsFormState createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  @override
  Widget build(BuildContext context) {
    Coach coach = Provider.of<Coach>(context);
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          TextFormField(
            controller: TextEditingController(text: coach.team.teamName),
            onChanged: (val) => coach.team.teamName = val,
            onFieldSubmitted: (val) => coach.sendTeamData(),
          ),
          TextFormField(
            controller: TextEditingController(text: coach.team.teamMascot),
            onChanged: (val) => coach.team.teamMascot = val,
            onFieldSubmitted: (val) => coach.sendTeamData(),
          )
        ]));
  }
}

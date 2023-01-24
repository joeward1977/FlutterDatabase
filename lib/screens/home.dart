import 'package:flutter/material.dart';
import 'package:flutterdatabase/backend/authservice.dart';
import 'package:flutterdatabase/backend/constants.dart';
import 'package:flutterdatabase/screens/tabs/goals_table.dart';
import 'package:flutterdatabase/screens/tabs/match_table.dart';
import 'package:flutterdatabase/screens/tabs/roster_table.dart';
import 'package:flutterdatabase/screens/settings.dart';
import 'package:flutterdatabase/models/coach.dart';

class Home extends StatefulWidget {
  final Coach coach;

  const Home({super.key, required this.coach});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Variables to deal with data from Google Server
  final AuthService _auth = AuthService();
  late Coach coach;

  @override
  void initState() {
    coach = widget.coach;
    coach.loadTeamData().then((result) => {setState(() {})});
    super.initState();
  }

  // Method to save data to Google Firestore
  void save() {
    coach.sendTeamData();
    setState(() {});
  }

  /// The build method is what creates the GUI for the program
  @override
  Widget build(BuildContext context) {
    /// This method puts a widget we created for getting settings on the
    /// bottom panel of the app when the setttings button is pressed
    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: const SettingsForm());
          }).whenComplete(() {
        setState(() {}); // This refreshes the data when settings panel is done
      });
    }

    /// This is the main GUI layout
    /// The first part is the appBar which is at the top of the screen and
    /// hold the title and the Logout action button
    return Scaffold(
        appBar: AppBar(
          backgroundColor: headerColor,
          title: Text('${coach.team.teamName} - ${coach.team.teamMascot}'),
          actions: <Widget>[
            ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              onPressed: () async {
                save();
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.settings),
              label: const Text(''),
              onPressed: () async {
                showSettingsPanel();
              },
            ),
          ],
        ),
        // The body of the GUI cotains the DataTable in a ListView Widget
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.people)),
                    Tab(child: Text("Matches")),
                    Tab(child: Icon(Icons.sports_soccer)),
                  ],
                ),
                backgroundColor: headerColor,
              ),
              body: TabBarView(
                children: [
                  RosterTable(coach: coach),
                  MatchTable(coach: coach),
                  const GoalsTable(),
                ],
              ),
            )));
  }
}

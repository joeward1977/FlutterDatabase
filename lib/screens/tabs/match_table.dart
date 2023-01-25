import 'package:flutter/material.dart';
import 'package:flutterdatabase/backend/constants.dart';
import 'package:flutterdatabase/models/coach.dart';
import 'package:flutterdatabase/models/match.dart';
import 'package:flutterdatabase/models/player.dart';

class MatchTable extends StatefulWidget {
  final Coach coach;

  const MatchTable({super.key, required this.coach});

  @override
  MatchTableState createState() => MatchTableState();
}

class MatchTableState extends State<MatchTable> {
  late Coach coach;
  // Variables for helping with the data table of players
  bool _isSortAsc = true;
  int _currentSortColumn = 0;
  List<String> selectedMatches = [];

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

  // Method to sort data table
  void sort(int col) {
    setState(() {
      if (_isSortAsc) {
        coach.team.matches
            .sort((a, b) => b.getSortValue(col).compareTo(a.getSortValue(col)));
      } else {
        coach.team.matches
            .sort((a, b) => a.getSortValue(col).compareTo(b.getSortValue(col)));
      }
      _isSortAsc = !_isSortAsc;
    });
  }

  /// The following methods create the data table
  /// This method puts it all together and styles the table
  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
      dividerThickness: 3,
      dataRowHeight: 35,
      showBottomBorder: true,
      headingTextStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => headerColor),
    );
  }

  // This method gets the column headings and makes columns sortable
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: const Text('Date'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.fName);
        },
      ),
      DataColumn(
        label: const Text('Opponent'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.lName);
        },
      ),
      const DataColumn(
        label: Text('Score'),
      ),
      const DataColumn(
        label: Text('Opponent Score'),
      ),
    ];
  }

  // This method put the data into each rom
  List<DataRow> _createRows() {
    List<DataRow> data = [];
    for (Match match in coach.team.matches) {
      data.add(DataRow(
          onSelectChanged: (val) {
            if (val!) {
              selectedMatches.add(match.id);
            } else {
              selectedMatches.remove(match.id);
            }
            setState(() {});
          },
          selected: selectedMatches.contains(match.id),
          cells: [
            DataCell(TextFormField(
              controller:
                  TextEditingController(text: match.matchDate.toString()),
              keyboardType: TextInputType.name,
              onChanged: (val) {
                coach.team.getMatch(match.id)!.matchDate = val;
              },
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller: TextEditingController(text: match.opponent),
              keyboardType: TextInputType.name,
              onChanged: (val) => coach.team.getMatch(match.id)!.opponent = val,
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller:
                  TextEditingController(text: match.teamScore.toString()),
              onChanged: (val) {
                var teamScore = int.tryParse(val);
                if (teamScore is int) {
                  coach.team.getMatch(match.id)!.teamScore = teamScore;
                }
              },
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller:
                  TextEditingController(text: match.opponentScore.toString()),
              onChanged: (val) {
                var oppScore = int.tryParse(val);
                if (oppScore is int) {
                  coach.team.getMatch(match.id)!.opponentScore = oppScore;
                }
              },
              onFieldSubmitted: (value) => save(),
            )),
          ]));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // The body of the GUI cotains the DataTable in a ListView Widget
        body: Container(
            color: backgroundColor,
            child: ListView(
              children: [FittedBox(child: _createDataTable())],
            )),

        /// The bottom has a navigation bar for actions you wish to have
        /// We have a settings putton, an add button, and a delete button
        bottomNavigationBar: BottomAppBar(
          color: headerColor,
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    coach.team.addMatch();
                    setState(() {});
                  }),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showAlertDialog("Delete Selected Matches");
                    setState(() {});
                  }),
            ],
          ),
        ));
  }

  Future<void> _showAlertDialog(String mainText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mainText),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                coach.team.deleteMatches(selectedMatches);
                save();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

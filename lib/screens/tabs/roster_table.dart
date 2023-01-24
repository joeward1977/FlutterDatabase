import 'package:flutter/material.dart';
import 'package:flutterdatabase/backend/constants.dart';
import 'package:flutterdatabase/models/coach.dart';
import 'package:flutterdatabase/models/player.dart';

class RosterTable extends StatefulWidget {
  final Coach coach;

  const RosterTable({super.key, required this.coach});

  @override
  RosterTableState createState() => RosterTableState();
}

class RosterTableState extends State<RosterTable> {
  late Coach coach;
  // Variables for helping with the data table of players
  bool _isSortAsc = true;
  int _currentSortColumn = 0;
  List<String> selectedPlayers = [];

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
        coach.team.players
            .sort((a, b) => b.getSortValue(col).compareTo(a.getSortValue(col)));
      } else {
        coach.team.players
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
        label: const Text('First Name'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.fName);
        },
      ),
      DataColumn(
        label: const Text('Last Name'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.lName);
        },
      ),
      DataColumn(
        label: const Text('Position'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.pos);
        },
      ),
      DataColumn(
        label: const Text('Number'),
        onSort: (columnIndex, _) {
          _currentSortColumn = columnIndex;
          sort(Player.jerseyNum);
        },
      ),
    ];
  }

  // This method put the data into each rom
  List<DataRow> _createRows() {
    List<DataRow> data = [];
    for (Player player in coach.team.players) {
      data.add(DataRow(
          onSelectChanged: (val) {
            if (val!) {
              selectedPlayers.add(player.id);
            } else {
              selectedPlayers.remove(player.id);
            }
            setState(() {});
          },
          selected: selectedPlayers.contains(player.id),
          cells: [
            DataCell(TextFormField(
              controller: TextEditingController(text: player.firstName),
              keyboardType: TextInputType.name,
              onChanged: (val) =>
                  coach.team.getPlayer(player.id)!.firstName = val,
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller: TextEditingController(text: player.lastName),
              keyboardType: TextInputType.name,
              onChanged: (val) =>
                  coach.team.getPlayer(player.id)!.lastName = val,
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller: TextEditingController(text: player.position),
              onChanged: (val) =>
                  coach.team.getPlayer(player.id)!.position = val,
              onFieldSubmitted: (val) => save(),
            )),
            DataCell(TextFormField(
              controller:
                  TextEditingController(text: player.jerseyNumber.toString()),
              onChanged: (val) {
                var jersey = int.tryParse(val);
                if (jersey is int) {
                  coach.team.getPlayer(player.id)!.jerseyNumber = jersey;
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
        body: ListView(
          children: [FittedBox(child: _createDataTable())],
        ),

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
                    coach.team.addPlayer();
                    setState(() {});
                  }),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showAlertDialog("Delete Selected Players");
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
                coach.team.deletePlayers(selectedPlayers);
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

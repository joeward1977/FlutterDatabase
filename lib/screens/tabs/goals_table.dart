import 'package:flutter/material.dart';
import 'package:flutterdatabase/backend/constants.dart';
import 'package:flutterdatabase/backend/database_service.dart';
import 'package:flutterdatabase/models/player.dart';

class GoalsTable extends StatefulWidget {
  const GoalsTable({super.key});

  @override
  GoalsTableState createState() => GoalsTableState();
}

class GoalsTableState extends State<GoalsTable> {
  late List<Player> allPlayers;
  // Variables for helping with the data table of players
  bool _isSortAsc = true;
  int _currentSortColumn = 0;
  List<String> selectedPlayers = [];

  @override
  void initState() {
    DatabaseService dbService = DatabaseService();
    allPlayers = [];
    dbService.getAllPlayers().then((result) => {
          setState(() {
            allPlayers = dbService.allPlayers;
          })
        });
    super.initState();
  }

  // Method to sort data table
  void sort(int col) {
    setState(() {
      if (_isSortAsc) {
        allPlayers
            .sort((a, b) => b.getSortValue(col).compareTo(a.getSortValue(col)));
      } else {
        allPlayers
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
    for (Player player in allPlayers) {
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
            )),
            DataCell(TextFormField(
              controller: TextEditingController(text: player.lastName),
              keyboardType: TextInputType.name,
            )),
            DataCell(TextFormField(
              controller: TextEditingController(text: player.position),
            )),
            DataCell(TextFormField(
              controller:
                  TextEditingController(text: player.jerseyNumber.toString()),
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
            )));
  }
}

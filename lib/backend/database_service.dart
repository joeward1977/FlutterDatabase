import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatabase/main.dart';
import 'package:flutterdatabase/models/player.dart';
import 'package:flutterdatabase/models/team.dart';

class DatabaseService {
  List<Player> allPlayers = [];
  List<Team> allTeams = [];

  DatabaseService();

  // Populate list of all teams from Firestore
  Future teamListFromSnapshot() async {
    QuerySnapshot snapshot = await firestoreDB.collection("users").get();
    allTeams = snapshot.docs.map((theMap) {
      return Team(
          teamName: theMap['teamName'],
          teamMascot: theMap['teamMascot'],
          matches: Team.mapToMatchList(theMap['matches']),
          players: Team.mapToPlayersList(theMap['players']));
    }).toList();
  }

  // Populate list of all players from everyteam
  Future getAllPlayers() async {
    allPlayers = [];
    await teamListFromSnapshot();
    for (Team curTeam in allTeams) {
      allPlayers.addAll(curTeam.players);
    }
  }
}

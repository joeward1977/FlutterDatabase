import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutterdatabase/models/player.dart';
import 'package:flutterdatabase/models/match.dart';

var uuid = const Uuid();

class Team {
  String teamName;
  String teamMascot;
  List<Match> matches;
  List<Player> players;

  Team({
    required this.teamName,
    required this.teamMascot,
    required this.matches,
    required this.players,
  });

  Team.newTeam()
      : this(
            teamName: "School Name",
            teamMascot: "Mascot",
            matches: [],
            players: []);

  Player? getPlayer(String id) {
    for (Player cur in players) {
      if (cur.id == id) {
        return cur;
      }
    }
    return null;
  }

  Match? getMatch(String id) {
    for (Match cur in matches) {
      if (cur.id == id) {
        return cur;
      }
    }
    return null;
  }

  void addPlayer() {
    players.add(Player(uuid.v1()));
  }

  void deletePlayers(List<String> ids) {
    for (String id in ids) {
      players.remove(getPlayer(id));
    }
  }

  void addMatch() {
    Match match = Match(uuid.v1());
    matches.add(match);
  }

  void deleteMatches(List<String> ids) {
    for (String id in ids) {
      matches.remove(getMatch(id));
    }
  }

  // Methods to convert team data to Map
  Map<String, dynamic> toMap() {
    return {
      "teamName": teamName,
      "teamMascot": teamMascot,
      "matches": matchesToMap(),
      "players": playersToMap(),
    };
  }

  List<Map> playersToMap() {
    List<Map> playersMap = [];
    for (int i = 0; i < players.length; i++) {
      playersMap.add(players[i].toMap());
    }
    return playersMap;
  }

  List<Map> matchesToMap() {
    List<Map> matchMap = [];
    for (int i = 0; i < matches.length; i++) {
      matchMap.add(matches[i].toMap());
    }
    return matchMap;
  }

  // Methods to get a Team object from Firestore Map Data
  static Team fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Team(
        teamName: data?['teamName'],
        teamMascot: data?['teamMascot'],
        matches: mapToMatchList(data?['matches']),
        players: mapToPlayersList(data?['players']));
  }

  static List<Player> mapToPlayersList(List<dynamic> playerMaps) {
    List<Player> thePlayers = [];
    for (var map in playerMaps) {
      thePlayers.add(Player.mapToObject(map));
    }
    return thePlayers;
  }

  static List<Match> mapToMatchList(List<dynamic> matchMaps) {
    List<Match> theMatches = [];
    for (var map in matchMaps) {
      theMatches.add(Match.mapToObject(map));
    }
    return theMatches;
  }
}

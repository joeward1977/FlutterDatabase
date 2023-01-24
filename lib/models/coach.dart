import 'package:flutterdatabase/main.dart';
import 'package:flutterdatabase/models/team.dart';

class Coach {
  final String uid;
  late Team team = Team.newTeam();

  Coach({required this.uid});

  void sendTeamData() async {
    final docRef = firestoreDB
        .collection("users")
        .withConverter(
          fromFirestore: Team.fromFirestore,
          toFirestore: (Team team, options) => team.toMap(),
        )
        .doc(uid);
    await docRef.set(team);
  }

  Future loadTeamData() async {
    team.players = [];
    final docRef = firestoreDB.collection("users").doc(uid).withConverter(
          fromFirestore: Team.fromFirestore,
          toFirestore: (Team team, _) => team.toMap(),
        );
    final docSnap = await docRef.get();
    team = docSnap.data()!; // Convert to Team object
  }
}

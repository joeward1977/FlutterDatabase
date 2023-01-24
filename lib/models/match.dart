class Match {
  static const int date = 0;
  static const int opp = 1;

  String id;
  String matchDate;
  String opponent;
  int teamScore;
  int opponentScore;

  Match(var id)
      : this.withData(
            id: id,
            matchDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString()
                .substring(0, 10),
            opponent: "",
            teamScore: 0,
            opponentScore: 0);

  Match.withData(
      {required this.id,
      required this.matchDate,
      required this.opponent,
      required this.teamScore,
      required this.opponentScore});

  dynamic getSortValue(int index) {
    switch (index) {
      case date:
        return matchDate;
      case opp:
        return opponent;
      default:
        return matchDate;
    }
  }

  static Match mapToObject(Map<String, dynamic> theMap) {
    return Match.withData(
      id: theMap['id'],
      matchDate: theMap['date'],
      opponent: theMap['opponent'],
      teamScore: theMap['teamScore'],
      opponentScore: theMap['opponentScore'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": matchDate,
      "opponent": opponent,
      "teamScore": teamScore,
      "opponentScore": opponentScore,
    };
  }
}

class Player {
  static const int fName = 0;
  static const int lName = 1;
  static const int pos = 2;
  static const int jerseyNum = 3;

  String id;
  String firstName;
  String lastName;
  String position;
  int jerseyNumber;

  Player(var id)
      : this.withData(
            id: id, firstName: "", lastName: "", position: "", jerseyNumber: 0);

  Player.withData(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.position,
      required this.jerseyNumber});

  dynamic getSortValue(int index) {
    switch (index) {
      case fName:
        return firstName;
      case lName:
        return lastName;
      case pos:
        return position;
      case jerseyNum:
        return jerseyNumber;
      default:
        return firstName;
    }
  }

  static Player mapToObject(Map<String, dynamic> theMap) {
    return Player.withData(
      id: theMap['id'].toString(),
      firstName: theMap['firstName'],
      lastName: theMap['lastName'],
      position: theMap['position'],
      jerseyNumber: theMap['jerseyNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "position": position,
      "jerseyNumber": jerseyNumber,
    };
  }
}

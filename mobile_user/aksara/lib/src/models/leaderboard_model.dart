class LeaderboardModel {
  List<_User> _users = [];

  LeaderboardModel.fromJson(Map<String, dynamic> parsedJson) {
    List<_User> temp = [];
    for (int i = 0; i < parsedJson['users'].length; i++) {
      _User user = _User(parsedJson['users'][i]);
      temp.add(user);
    }
    _users = temp;
  }

  get users => _users;
}

class _User {
  String _email;
  int _level;
  String _name;
  String _faculty;
  String _department;
  String _studyProgram;
  String _generation;
  String _createdAt;
  int _point;

  _User(data) {
    _email = data['email'];
    _level = data['level'];
    _name = data['name'];
    _faculty = data['faculty'];
    _department = data['department'];
    _studyProgram = data['studyProgram'];
    _generation = data['generation'];
    _createdAt = data['createdAt'];
    _point = data['point'];
  }

  get email => _email;
  get level => _level;
  get name => _name;
  get faculty => _faculty;
  get department => _department;
  get studyProgram => _studyProgram;
  get generation => _generation;
  get createdAt => _createdAt;
  get point => _point;
}

class UserModel {
  User _data;

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    _data = User(parsedJson['data']);
  }

  UserModel.fromObj(User user) {
    _data = user;
  }

  get data => _data;
}

class User {
  int _id;
  String _email;
  int _level;
  String _name;
  String _faculty;
  String _department;
  String _studyProgram;
  String _generation;
  bool _isActive;
  String _createdAt;
  String _updatedAt;

  User(data) {
    _id = data['id'];
    _email = data['email'];
    _level = data['level'];
    _name = data['name'];
    _faculty = data['faculty'];
    _department = data['department'];
    _studyProgram = data['studyProgram'];
    _generation = data['generation'];
    _isActive = data['isActive'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
  }

  get id => _id;
  get email => _email;
  get level => _level;
  get name => _name;
  get faculty => _faculty;
  get department => _department;
  get studyProgram => _studyProgram;
  get generation => _generation;
  get isActive => _isActive;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
}

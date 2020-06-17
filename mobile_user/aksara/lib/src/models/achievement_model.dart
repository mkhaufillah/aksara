class AchievementModel {
  _Achievement _content;

  AchievementModel.fromJson(Map<String, dynamic> parsedJson) {
    _content = _Achievement(parsedJson['content']);
  }

  AchievementModel.init() {
    Map<String, dynamic> dataInit = Map<String, dynamic>();
    dataInit['id'] = null;
    dataInit['level'] = null;
    dataInit['point'] = null;
    dataInit['rank'] = null;
    _content = _Achievement(dataInit);
  }

  get content => _content;
}

class _Achievement {
  int _id;
  int _level;
  int _point;
  int _rank;

  _Achievement(data) {
    _id = data['id'];
    _level = data['level'];
    _point = data['point'];
    _rank = data['rank'];
  }

  get id => _id;
  get level => _level;
  get point => _point;
  get rank => _rank;
}

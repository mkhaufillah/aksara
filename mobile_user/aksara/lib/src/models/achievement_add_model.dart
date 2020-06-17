class AchievementAddModel {
  _Achievement _content;

  AchievementAddModel.fromJson(Map<String, dynamic> parsedJson) {
    _content = _Achievement(parsedJson['content']);
  }

  get content => _content;
}

class _Achievement {
  int _pointAdd;
  int _rankAdd;
  int _levelNow;
  int _modPoint;

  _Achievement(data) {
    _pointAdd = data['pointAdd'];
    _rankAdd = data['rankAdd'];
    _levelNow = data['levelNow'];
    _modPoint = data['modPoint'];
  }

  get pointAdd => _pointAdd;
  get rankAdd => _rankAdd;
  get levelNow => _levelNow;
  get modPoint => _modPoint;
}

class HistoryModel {
  List<_History> _histories = [];

  HistoryModel.fromJson(Map<String, dynamic> parsedJson) {
    List<_History> temp = [];
    for (int i = 0; i < parsedJson['histories'].length; i++) {
      _History history = _History(parsedJson['histories'][i]);
      temp.add(history);
    }
    _histories = temp;
  }

  get histories => _histories;
}

class _History {
  int _point;
  int _completedQuiz;
  String _createdAt;

  _History(data) {
    _point = data['point'];
    _completedQuiz = data['completedQuiz'];
    _createdAt = data['createdAt'];
  }

  get point => _point;
  get completedQuiz => _completedQuiz;
  get createdAt => _createdAt;
}

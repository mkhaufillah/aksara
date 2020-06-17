class QuizModel {
  List<Quiz> _quizes = [];

  QuizModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Quiz> temp = [];
    for (int i = 0; i < parsedJson['quizes'].length; i++) {
      Quiz quiz = Quiz(parsedJson['quizes'][i]);
      temp.add(quiz);
    }
    _quizes = temp;
  }

  get quizes => _quizes;
}

class Quiz {
  int _id;
  String _title;
  String _question;
  String _createdAt;
  String _updatedAt;
  int _contentId;
  List<_Answer> _answers;

  Quiz(data) {
    _id = data['id'];
    _title = data['title'];
    _question = data['question'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
    _contentId = data['contentId'];
    List<_Answer> temp = [];
    for (int i = 0; i < data['answers'].length; i++) {
      _Answer answer = _Answer(data['answers'][i]);
      temp.add(answer);
    }
    _answers = temp;
  }

  get id => _id;
  get title => _title;
  get question => _question;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
  get contentId => _contentId;
  get answer => _answers;
}

class _Answer {
  int _id;
  String _title;
  String _answer;
  String _color;
  String _textColor;
  bool _isCorrect;
  String _createdAt;
  String _updatedAt;
  int _quizId;

  _Answer(data) {
    _id = data['id'];
    _title = data['title'];
    _answer = data['answer'];
    _color = data['color'];
    _textColor = data['textColor'];
    _isCorrect = data['isCorrect'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
    _quizId = data['quizId'];
  }

  get id => _id;
  get title => _title;
  get answer => _answer;
  get color => _color;
  get textColor => _textColor;
  get isCorrect => _isCorrect;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
  get quizId => _quizId;
}

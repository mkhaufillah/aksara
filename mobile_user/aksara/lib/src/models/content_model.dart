class ContentModel {
  List<Content> _contents = [];

  ContentModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Content> temp = [];
    for (int i = 0; i < parsedJson['contents'].length; i++) {
      Content history = Content(parsedJson['contents'][i]);
      temp.add(history);
    }
    _contents = temp;
  }

  get contents => _contents;
}

class Content {
  int _id;
  String _title;
  String _content;
  String _santun;
  String _akrab;
  String _copy;
  String _link;
  String _createdAt;
  String _updatedAt;
  int _subDocumentId;
  List<_Dialog> _dialogs;

  Content(data) {
    _id = data['id'];
    _title = data['title'];
    _content = data['content'];
    _santun = data['santun'];
    _akrab = data['akrab'];
    _copy = data['copy'];
    _link = data['link'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
    _subDocumentId = data['subDocumentId'];
    List<_Dialog> temp = [];
    for (int i = 0; i < data['dialogs'].length; i++) {
      _Dialog dialog = _Dialog(data['dialogs'][i]);
      temp.add(dialog);
    }
    _dialogs = temp;
  }

  get id => _id;
  get title => _title;
  get content => _content;
  get santun => _santun;
  get akrab => _akrab;
  get copy => _copy;
  get link => _link;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
  get subDocumentId => _subDocumentId;
  get dialogs => _dialogs;
}

class _Dialog {
  int _id;
  String _content;
  String _createdAt;
  String _updatedAt;
  int _contentId;

  _Dialog(data) {
    _id = data['id'];
    _content = data['content'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
    _contentId = data['contentId'];
  }

  get id => _id;
  get content => _content;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
  get contentId => _contentId;
}

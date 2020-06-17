class DocumentModel {
  List<Document> _documents = [];

  DocumentModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Document> temp = [];
    for (int i = 0; i < parsedJson['documents'].length; i++) {
      Document history = Document(parsedJson['documents'][i]);
      temp.add(history);
    }
    _documents = temp;
  }

  get documents => _documents;
}

class Document {
  int _id;
  String _title;
  String _createdAt;
  String _updatedAt;

  Document(data) {
    _id = data['id'];
    _title = data['title'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
  }

  get id => _id;
  get title => _title;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
}

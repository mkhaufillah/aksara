class SubDocumentModel {
  List<SubDocument> _subDocuments = [];

  SubDocumentModel.fromJson(Map<String, dynamic> parsedJson) {
    List<SubDocument> temp = [];
    for (int i = 0; i < parsedJson['subDocuments'].length; i++) {
      SubDocument history = SubDocument(parsedJson['subDocuments'][i]);
      temp.add(history);
    }
    _subDocuments = temp;
  }

  get subDocuments => _subDocuments;
}

class SubDocument {
  int _id;
  String _title;
  String _createdAt;
  String _updatedAt;
  int _documentId;

  SubDocument(data) {
    _id = data['id'];
    _title = data['title'];
    _createdAt = data['createdAt'];
    _updatedAt = data['updatedAt'];
    _documentId = data['documentId'];
  }

  get id => _id;
  get title => _title;
  get createdAt => _createdAt;
  get updatedAt => _updatedAt;
  get documentId => _documentId;
}

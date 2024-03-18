
class UniqueSubsModel {
  late bool _error ;
  late List<_UniqueSubsField> _data = [];

  UniqueSubsModel.fromJson(Map<String, dynamic> parsedJson) {
    // print(parsedJson['data'].length);
    _error = parsedJson['error'];
    List<_UniqueSubsField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _UniqueSubsField result = _UniqueSubsField(parsedJson['data'][i]);
      temp.add(result);
    }
    _data = temp;
  }


  bool get error => _error;

  List<_UniqueSubsField> get data => _data;

}

class _UniqueSubsField{
  late String _id;
  late String _name;
  late String _grp_id;

  _UniqueSubsField(data){
    _id = data['id'];
    _name = data['name'];
    _grp_id = data['grp_id'];
  }

  String get id => _id;

  String get name => _name;

  String get grp_id => _grp_id;

}
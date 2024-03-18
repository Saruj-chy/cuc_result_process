class StudentModel {
  late bool _error ;
  late List<_StudentField> _data = [];

  StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_StudentField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _StudentField result = _StudentField(parsedJson['data'][i]);
      temp.add(result);
    }
    _data = temp;
  }

  List<_StudentField> get data => _data;

  bool get error => _error;
}


class _StudentField{
  late String _id;
  late String _name;
  late String _roll;
  late String _sess_id;
  late String _grp_id;
  late String _optional_sub_id;

  _StudentField(data){
    _id = data['id'];
    _name = data['name'];
    _roll = data['roll'];
    _sess_id = data['sess_id'];
    _grp_id = data['grp_id'];
    _optional_sub_id = data['optional_sub_id'];

  }

  String get optional_sub_id => _optional_sub_id;

  String get grp_id => _grp_id;

  String get sess_id => _sess_id;

  String get roll => _roll;

  String get name => _name;

  String get id => _id;
}
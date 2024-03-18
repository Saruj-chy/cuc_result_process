class TeacherModel {
  late bool _error ;
  late List<_TeacherField> _data = [];

  TeacherModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_TeacherField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _TeacherField result = _TeacherField(parsedJson['data'][i]);
      temp.add(result);
    }

    _data = temp;
  }


  bool get error => _error;

  List<_TeacherField> get data => _data;

}


class _TeacherField{
  late String _id;
  late String _role_id;
  late String _role_name;
  late String _teacher_name;
  late String _phn_num;

  _TeacherField(data){
    _id = data['id'];
    _role_id = data['role_id'];
    _role_name = data['role_name'];
    _teacher_name = data['teacher_name'];
    _phn_num = data['phn_num'];

  }

  String get phn_num => _phn_num;

  String get teacher_name => _teacher_name;

  String get role_name => _role_name;

  String get role_id => _role_id;

  String get id => _id;
}

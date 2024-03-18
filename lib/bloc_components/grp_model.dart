class GrpModel {
  late bool _error ;
  late List<_GrpField> _data = [];

  GrpModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_GrpField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _GrpField result = _GrpField(parsedJson['data'][i]);
      temp.add(result);
    }

    _data = temp;
  }


  bool get error => _error;

  List<_GrpField> get data => _data;

}


class _GrpField{
  late String _id;
  late String _name;

  _GrpField(data){
    _id = data['id'];
    _name = data['name'];

  }

  String get name => _name;

  String get id => _id;
}

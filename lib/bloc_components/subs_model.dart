
class SubsModel {
  late bool _error ;
  late List<_SubsField> _data = [];

  SubsModel.fromJson(Map<String, dynamic> parsedJson) {
    // print(parsedJson['data'].length);
    _error = parsedJson['error'];
    List<_SubsField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _SubsField result = _SubsField(parsedJson['data'][i]);
      temp.add(result);
    }
    _data = temp;
  }


  bool get error => _error;

  List<_SubsField> get data => _data;

}







class _SubsField{
  late String _id;
  late String _name;
  late String _title;
  late String _code;
  late String _grp_id;

  _SubsField(data){
    _id = data['id'];
    _name = data['name'];
    _title = data['title'];
    _code = data['code'];
    _grp_id = data['grp_id'];
  }

  String get id => _id;

  String get name => _name;

  String get grp_id => _grp_id;

  String get code => _code;

  String get title => _title;
}
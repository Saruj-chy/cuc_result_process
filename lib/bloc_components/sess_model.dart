class SessModel {
  late bool _error ;
  late List<_SessField> _data = [];
  late List<_SubField> _subs = [];

  SessModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_SessField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _SessField result = _SessField(parsedJson['data'][i]);
      temp.add(result);
    }
    List<_SubField> tempSubs = [];
    for (int i = 0; i < parsedJson['subs'].length; i++) {
      _SubField subs = _SubField(parsedJson['subs'][i]);
      tempSubs.add(subs);
    }
    _data = temp;
    _subs = tempSubs;
  }


  bool get error => _error;

  List<_SessField> get data => _data;

  List<_SubField> get subs => _subs;
}


class _SessField{
  late String _id;
  late String _name;

  _SessField(data){
    _id = data['id'];
    _name = data['name'];

  }

  String get name => _name;

  String get id => _id;
}
class _SubField{
  late String _grp_sub_id;
  late String _grp_id;
  late String _grp_name;
  late String _name;
  late String _title;
  late String _code;

  _SubField(data){
    _grp_sub_id = data['grp_sub_id'];
    _grp_id = data['grp_id'];
    _grp_name = data['grp_name'];
    _name = data['name'];
    _title = data['title'];
    _code = data['code'];
  }

  String get code => _code;

  String get title => _title;

  String get name => _name;

  String get grp_name => _grp_name;

  String get grp_id => _grp_id;

  String get grp_sub_id => _grp_sub_id;
}
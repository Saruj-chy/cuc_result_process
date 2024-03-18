class TranscriptModel {
  late bool _error ;
  late List<_TranscriptStuModel> _data = [];

  TranscriptModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_TranscriptStuModel> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _TranscriptStuModel result = _TranscriptStuModel(parsedJson['data'][i]);
      temp.add(result);
    }

    _data = temp;
  }

  List<_TranscriptStuModel> get data => _data;

  bool get error => _error;
}

class _TranscriptStuModel{
  late String _stu_id ;
  late String? _grp_id ;
  late String _grp_name ;
  late String _name ;
  late String _roll ;
  late String _optional_sub_id ;
  late String _sess_name ;
  late List<_TranscriptSubField> _stu_data = [];


  _TranscriptStuModel(data){
    _stu_id = data['stu_id'];
    _grp_id = data['grp_id'];
    _grp_name = data['grp_name'];
    _name = data['name'];
    _roll = data['roll'];
    _optional_sub_id = data['optional_sub_id'];
    _sess_name = data['sess_name'];
    List<_TranscriptSubField> temp = [];
    for (int i = 0; i < data["$_stu_id"].length; i++) {
      _TranscriptSubField result = _TranscriptSubField(data["$_stu_id"][i]);
      temp.add(result);
    }
    _stu_data = temp;
  }

  List<_TranscriptSubField> get stu_data => _stu_data;

  String get stu_id => _stu_id;

  String get optional_sub_id => _optional_sub_id;

  String get roll => _roll;

  String get name => _name;


  String? get grp_id => _grp_id;

  String get grp_name => _grp_name;

  String get sess_name => _sess_name;
}
class _TranscriptSubField{
  late String _id;
  late String _sub_name_id;
  late String _sub_name;
  late String _code;
  late String _optional_sub_id;
  late String _cq;
  late String _mcq;
  String? _practical;

  _TranscriptSubField(data){
    _id = data['id'];
    _sub_name_id = data['sub_name_id'];
    _sub_name = data['sub_name'];
    _code = data['code'];
    _optional_sub_id = data['optional_sub_id'];
    _cq = data['cq'];
    _mcq = data['mcq'];
    _practical = data['practical'];

  }


  String get sub_name => _sub_name;

  String get sub_name_id => _sub_name_id;

  String get id => _id;

  String get code => _code;

  String get optional_sub_id => _optional_sub_id;

  String get cq => _cq;

  String get mcq => _mcq;

  String? get practical => _practical;
}



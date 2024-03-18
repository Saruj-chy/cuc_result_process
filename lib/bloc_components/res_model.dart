class ResultModel {
  late bool _error ;
  late List<_ResultField> _data = [];
  // late List<SubsField> data = [];

  ResultModel.fromJson(Map<String, dynamic> parsedJson) {
    // print(parsedJson['data'].length);
    _error = parsedJson['error'];
    List<_ResultField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _ResultField result = _ResultField(parsedJson['data'][i]);
      temp.add(result);
    }
    _data = temp;
  }


  bool get error => _error;

  List<_ResultField> get data => _data;

}


class _ResultField{
  late String _id;
  late String _stu_id;
  late String _user_id;
  late String _grp_sub_id;
  late String _exam_id;
  late String _cq;
  late String _mcq;
  late String _practical;
  late String _update_number;
  late String _update;
  late String _current_date_time;

  _ResultField(data){
    _id = data['id'];
    _stu_id = data['stu_id'];
    _user_id = data['user_id'];
    _grp_sub_id = data['grp_sub_id'];
    _exam_id = data['exam_id'];
    _cq = data['cq'];
    _mcq = data['mcq'];
    _practical = data['practical'];
    _update_number = data['update_number'];
    _update = data['update'];
    _current_date_time = data['current_date_time'];

  }

  String get current_date_time => _current_date_time;

  String get update_number => _update_number;

  String get practical => _practical;

  String get mcq => _mcq;

  String get cq => _cq;

  String get exam_id => _exam_id;

  String get grp_sub_id => _grp_sub_id;

  String get user_id => _user_id;

  String get stu_id => _stu_id;


  String get update => _update;

  String get id => _id;
}
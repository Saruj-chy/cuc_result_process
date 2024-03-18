class HistoryModel {
  late bool _error ;
  late List<_HistoryField> _data = [];

  HistoryModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_HistoryField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _HistoryField result = _HistoryField(parsedJson['data'][i]);
      temp.add(result);
    }

    _data = temp;
  }


  bool get error => _error;

  List<_HistoryField> get data => _data;

}


class _HistoryField{
  late String _id;
  late String _msg;
  late String _user_id;
  late String _stu_id;
  late String _res_id;
  late String _admin_id;
  late String _sess_id;
  late String _current_date;

  _HistoryField(data){
    _id = data['id'];
    _msg = data['msg'];
    _user_id = data['user_id'];
    _stu_id = data['stu_id'];
    _sess_id = data['sess_id'];
    _res_id = data['res_id'];
    _admin_id = data['admin_id'];
    _current_date = data['current_date'];

  }

  String get current_date => _current_date;

  String get sess_id => _sess_id;

  String get admin_id => _admin_id;

  String get res_id => _res_id;

  String get stu_id => _stu_id;

  String get user_id => _user_id;

  String get msg => _msg;

  String get id => _id;
}

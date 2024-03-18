class TopicModel {
  late bool _error ;
  late List<_TopicsField> _data = [];

  TopicModel.fromJson(Map<String, dynamic> parsedJson) {
    _error = parsedJson['error'];
    List<_TopicsField> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _TopicsField result = _TopicsField(parsedJson['data'][i]);
      temp.add(result);
    }
    _data = temp;
  }

  List<_TopicsField> get data => _data;

  bool get error => _error;
}


class _TopicsField{
  late String _grp_sub_id;
  late String _grp_id;
  late String _name;
  late String _title;
  late String _code;

  _TopicsField(data){
    _grp_sub_id = data['grp_sub_id'];
    _grp_id = data['grp_id'];
    _name = data['name'];
    _title = data['title'];
    _code = data['code'];

  }

  String get code => _code;

  String get title => _title;

  String get name => _name;

  String get grp_id => _grp_id;

  String get grp_sub_id => _grp_sub_id;
}
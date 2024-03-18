class SubCodeModel {
  String code;
  String sub_name_id;
  String title;

  SubCodeModel({required this.code, required this.sub_name_id, required this.title});

  @override
  String toString() {
    return 'SubCodeModel{'
        // 'code: $code,'
        ' sub_name_id: $sub_name_id, '
        // 'title: $title'
        '}';
  }
}
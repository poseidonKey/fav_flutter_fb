class CategoryModel {
  final String fa_no;
  final String fa_code;
  final String fa_name;

  CategoryModel({
    required this.fa_no,
    required this.fa_code,
    required this.fa_name,
  });
  CategoryModel.fromJson({required Map<String, dynamic> json})
      : fa_code = json['fa_code'],
        fa_no = json['fa_no'],
        fa_name = json['fa_name'];

  Map<String, dynamic> toJson() {
    return {
      'fa_no': fa_no,
      'fa_code': fa_code,
      'fa_name': fa_name,
    };
  }
}

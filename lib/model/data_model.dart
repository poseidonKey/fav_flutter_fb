class DataModel {
  final String no;
  final String name;
  final String url;
  final String code;
  final String alt;

  DataModel({
    required this.no,
    required this.name,
    required this.url,
    required this.code,
    required this.alt,
  });
  DataModel.fromJson({required Map<String, dynamic> json})
      : no = json['no'],
        name = json['name'],
        url = json['url'],
        code = json['code'],
        alt = json['alt'];

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'name': name,
      'url': url,
      'code': code,
      'alt': alt,
    };
  }
}

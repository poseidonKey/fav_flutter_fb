import 'package:dio/dio.dart';
import 'package:fav_flutter_fb/const/util.dart';
import 'package:fav_flutter_fb/model/data_model.dart';

class DataLoadRepository {
  final _dio = Dio();

  Future<List<DataModel>> getCategories({required String category}) async {
    // print(category);
    String targetUrl = '${Util.url}load_fav_data.php?category=$category';
    final resp = await _dio.get(targetUrl);
    // return resp.data;
    return resp.data
        .map<DataModel>(
          (x) => DataModel.fromJson(
            json: x,
          ),
        )
        .toList();
  }

  Future<String> deleteData({required String no}) async {
    // print(category);
    String targetUrl = '${Util.url}delete_fav_data.php?no=$no';
    await _dio.get(targetUrl);
    return 'delete Data';
  }
}

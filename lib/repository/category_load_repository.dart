import 'package:dio/dio.dart';
import 'package:fav_flutter_fb/const/util.dart';
import 'package:fav_flutter_fb/model/category_model.dart';

class CategoryLoadRepository {
  final _dio = Dio();
  final _targetUrl = '${Util.url}load_fav_category.php';

  Future<List<CategoryModel>> getCategories() async {
    final resp = await _dio.get(_targetUrl);
    return resp.data
        .map<CategoryModel>(
          (x) => CategoryModel.fromJson(
            json: x,
          ),
        )
        .toList();
  }

  Future<String> deleteCategory_all_data({required String id}) async {
    // print(category);
    String targetUrl = '${Util.url}delete_cate_data.php?no=$id';
    await _dio.get(targetUrl);
    return 'delete All Category And Data';
  }
}

import 'package:dio/dio.dart';
import 'package:fav_flutter_fb/const/util.dart';
import 'package:fav_flutter_fb/model/category_model.dart';
import 'package:fav_flutter_fb/repository/category_load_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryListProvider =
    StateNotifierProvider<CategoryListNotifier, List<CategoryModel>>(
  (ref) => CategoryListNotifier(),
);

class CategoryListNotifier extends StateNotifier<List<CategoryModel>> {
  CategoryListNotifier() : super([]) {
    final tmp = getCategoryData();
    tmp.then((value) => state = value);
  }

  Future<List<CategoryModel>> getCategoryData() async {
    CategoryLoadRepository repository = CategoryLoadRepository();
    final dbData = await repository.getCategories();
    return dbData;
  }

  Future<String> deleteCategory_all_data({required String id}) async {
    // print(category);
    final dio = Dio();
    String targetUrl = '${Util.url}delete_cate_data.php?no=$id';
    await dio.get(targetUrl);
    state = await getCategoryData();
    return 'delete All Category And Data';
  }
}

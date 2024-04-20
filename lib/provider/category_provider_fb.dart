import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_flutter_fb/model/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryListFirebaseProvider =
    StateNotifierProvider<CategoryList_fb_Notifier, List<CategoryModel?>>(
  (ref) => CategoryList_fb_Notifier(),
);

class CategoryList_fb_Notifier extends StateNotifier<List<CategoryModel?>> {
  CategoryList_fb_Notifier() : super([]) {
    final tmp = fetchCategoryDataAndSortByNo();
    tmp.then((value) => state = value);
  }

  Future<String> deleteCategory_all_data_fb(
      {required CategoryModel model}) async {
    print(model.fa_no);
    //firebase에서 자료 삭제하기
    try {
      // Reference to the Firestore collection
      final CollectionReference favDataCollection =
          FirebaseFirestore.instance.collection('favData');

      // Query documents to delete
      QuerySnapshot querySnapshot =
          await favDataCollection.where('code', isEqualTo: model.fa_code).get();

      // Create a WriteBatch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Iterate through query snapshot and add delete operations to batch
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();

      print('Batch delete operation completed successfully.');
    } catch (error) {
      print('Error deleting documents: $error');
    }

    // print(model.fa_no);
    await FirebaseFirestore.instance
        .collection('favCategory')
        .doc(model.fa_no)
        .delete();
    state = await fetchCategoryDataAndSortByNo();
    return 'delete All Category And Data';
  }

  Future<List<CategoryModel?>> fetchCategoryDataAndSortByNo() async {
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('favCategory').get();
    List<CategoryModel> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            CategoryModel.fromSnapshot(snapshot))
        .toList();
    data.sort((a, b) => (a.fa_code).compareTo(b.fa_code));
    return data;
  }

  void removeItem(int index) async {
    state.removeAt(index);
  }

  void undoRemoveItem(int index, CategoryModel item) async {
    state.insert(index, item);
    state = await fetchCategoryDataAndSortByNo();
  }
}

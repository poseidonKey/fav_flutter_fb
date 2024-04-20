import 'package:fav_flutter_fb/model/category_model.dart';
import 'package:fav_flutter_fb/provider/category_provider_fb.dart';
import 'package:fav_flutter_fb/screen/data_screen_fb.dart';
import 'package:fav_flutter_fb/screen/fire_base_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenFirebase extends ConsumerWidget {
  const HomeScreenFirebase({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryListFirebaseProvider);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * .07),
          child: AppBar(
            title: const Text(
              '[My Internet Favorites!! 😀] ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurpleAccent),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.face_2_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FirebaseCategoryScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const PreferredSize(
              preferredSize: Size.fromHeight(2.0), // Height of the Divider
              child: Divider(
                color: Colors.red,
                thickness: 2.0,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: state.length,
                itemBuilder: (BuildContext context, int index) {
                  final CategoryModel model = state[index]!;
                  return SizedBox(
                    height: 70,
                    child: Dismissible(
                      key: ObjectKey(model.fa_no),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                final removedCategory = state[index];
                                ref
                                    .read(categoryListFirebaseProvider.notifier)
                                    .removeItem(index);
                                return AlertDialog(
                                  title: const Text('카테고리 삭제'),
                                  content:
                                      const Text('카테고리와 연결 된 모든 데이터도 삭제 됩니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        ref
                                            .read(categoryListFirebaseProvider
                                                .notifier)
                                            .deleteCategory_all_data_fb(
                                                model: model);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('확인'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print(
                                            '$index, ${removedCategory!.fa_name}');
                                        ref
                                            .read(categoryListFirebaseProvider
                                                .notifier)
                                            .undoRemoveItem(
                                                index, removedCategory);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('취소'),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DataScreenFirebase(
                                category: model.fa_code,
                              ),
                            ),
                          );
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            '[${model.fa_code}] Category Title : ${model.fa_name}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 5,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

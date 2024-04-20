import 'package:fav_flutter_fb/model/category_model.dart';
import 'package:fav_flutter_fb/provider/category_provider.dart';
import 'package:fav_flutter_fb/screen/data_screen.dart';
import 'package:fav_flutter_fb/screen/fire_base_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CategoryModel> state = ref.watch(categoryListProvider);

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
                  final CategoryModel model = state[index];
                  return SizedBox(
                    height: 70,
                    child: Dismissible(
                      key: ObjectKey(model.fa_no),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          print(model.fa_no);
                          final result = await ref
                              .read(categoryListProvider.notifier)
                              .deleteCategory_all_data(id: model.fa_no);

                          if (result == 'delete All Category And Data') {
                            print('success');
                          } else {
                            print('error');
                          }
                        }
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DataScreen(
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

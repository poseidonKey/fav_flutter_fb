import 'package:fav_flutter_fb/model/data_model.dart';
import 'package:fav_flutter_fb/provider/data_provider.dart';
import 'package:fav_flutter_fb/screen/fire_base_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataScreen extends ConsumerWidget {
  final String category;
  const DataScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataNotifierProvider(category));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('내 즐겨찾기 Data'), actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FirebaseDataScreen(category: category),
                ),
              );
            },
            icon: const Icon(Icons.manage_search),
          ),
        ]),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.length,
                itemBuilder: (BuildContext context, int index) {
                  final DataModel model = state[index];
                  return Dismissible(
                    key: ObjectKey(model.no),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) async {
                      final result = await ref
                          .read(dataNotifierProvider(category).notifier)
                          .deleteData(no: model.no);
                      // final result = await repository.deleteData(no: model.no);
                      if (result == 'delete Data') {
                        print('success');
                      } else {
                        print('error');
                      }
                    },
                    child: ListTile(
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * .95,
                                height: MediaQuery.of(context).size.height * .5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    const Center(
                                      child: Text(
                                        'Data 정보',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'subject : ${model.name}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        'URL - ${model.url}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        'etc : ${model.alt}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('close')),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      title: Text(
                        '[${model.name}] - ${model.url}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16, top: 8, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

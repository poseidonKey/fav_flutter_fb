import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_flutter_fb/model/data_model.dart';
import 'package:fav_flutter_fb/screen/fire_base_data_screen.dart';
import 'package:flutter/material.dart';

class DataScreenFirebase extends StatelessWidget {
  final String category;
  const DataScreenFirebase({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.tab)),
          title: Text(
            '내 즐겨찾기 Data : [ $category ]',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurpleAccent),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        FirebaseDataScreen(category: category),
                  ),
                );
              },
              icon: const Icon(Icons.manage_search),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<DataModel?>>(
                future: fetchDataAndSortByNo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('정보를 가져오지 못했습니다.'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DataModel model = snapshot.data![index]!;
                      return Dismissible(
                        key: ObjectKey(model.no),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) async {},
                        child: ListTile(
                          onTap: () async {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .95,
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            style:
                                                const TextStyle(fontSize: 20),
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
                                            style:
                                                const TextStyle(fontSize: 20),
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
                                            style:
                                                const TextStyle(fontSize: 20),
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

  Future<List<DataModel?>> fetchDataAndSortByNo() async {
    // Fetch data from Firestore collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('favData')
        .where('code', isEqualTo: category)
        .get();
    List<DataModel> data = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            DataModel.fromSnapshot(snapshot))
        .toList();
    data.sort((a, b) => int.parse(a.no).compareTo(int.parse(b.no)));
    return data;
  }
}

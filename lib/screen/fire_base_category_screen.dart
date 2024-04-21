import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_flutter_fb/model/category_model.dart';
import 'package:fav_flutter_fb/provider/category_provider.dart';
import 'package:fav_flutter_fb/screen/search_screen_fb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseCategoryScreen extends ConsumerWidget {
  const FirebaseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Manager'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                await clearCollection('favCategory');
                print('success');
              },
              child: const Text('Category Delete'),
            ),
            FilledButton(
              onPressed: () async {
                final cateData = ref.read(categoryListProvider);
                await createCollection(
                    collectionName: 'favCategory', newData: cateData);
                print('success');
              },
              child: const Text('Category Add'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchScreenFirebase(),
                    ),
                  );
                },
                child: const Text('Search')),
            ElevatedButton(
                onPressed: () async {
                  print('test');
// Assuming you have a Firestore instance initialized somewhere in your code
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

// Query documents where the "name" array contains "Busan"
                  QuerySnapshot snapshot = await firestore
                      .collection('favData')
                      // .where('name', arrayContains: '부산')
                      // .where('no', arrayContains: '141')
                      // .where('name', isGreaterThanOrEqualTo: 'Coo')
                      // .where('name', isLessThan: 'Cou')
                      // .get();
                      // .where('name', isGreaterThanOrEqualTo: '부산')
                      // .where('name',
                      //     isLessThan:
                      //         '부산${String.fromCharCode('부산'.codeUnitAt(0) + 1)}') // Increment the first character to the next one in Unicode
                      // .get();
                      .where('name', isGreaterThanOrEqualTo: '부산')
                      .where('name',
                          isLessThan:
                              '부산${String.fromCharCode('부산'.codeUnitAt(0) + 1)}') // Increment the first character to the next one in Unicode
                      .get();

// Iterate over the documents in the snapshot
                  for (var doc in snapshot.docs) {
                    // Access document data using doc.data()
                    print(doc.data());
                  }
                },
                child: const Text('test'))
          ],
        ),
      ),
    );
  }

  Future<void> clearCollection(String collectionName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Delete all documents in the existing collection
    QuerySnapshot existingData =
        await firestore.collection(collectionName).get();
    for (DocumentSnapshot document in existingData.docs) {
      await document.reference.delete();
    }
  }

  Future<void> createCollection(
      {required String collectionName,
      required List<CategoryModel> newData}) async {
    // Create a new collection and add documents to it
    for (var imsi in newData) {
      // await firestore.collection(collectionName).add(data);
      final tmp = imsi.toJson();
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(tmp['fa_no'])
          .set(tmp);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_flutter_fb/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseDataScreen extends ConsumerWidget {
  final String category;
  const FirebaseDataScreen({required this.category, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 데이터 관리'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                final favData = ref.read(dataNotifierProvider(category));
                for (var imsi in favData) {
                  final tmp = imsi.toJson();
                  // print(tmp);
                  await FirebaseFirestore.instance
                      .collection('favData')
                      .doc(tmp['no'])
                      .set(tmp);
                }
                print('success');
              },
              child: Text(
                '현재 카테고리 [$category] 의 데이터 Add',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: () async {
                try {
                  // Reference to the Firestore collection
                  final CollectionReference favDataCollection =
                      FirebaseFirestore.instance.collection('favData');

                  // Query documents to delete
                  QuerySnapshot querySnapshot = await favDataCollection
                      .where('code', isEqualTo: category)
                      .get();

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
              },
              child: Text(
                '현재 카테고리 [$category] 의 데이터 Delete',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
                final cateData = ref.read(categoryListProvider);
                for (var imsi in cateData) {
                  final tmp = imsi.toJson();
                  print(tmp);
                  await FirebaseFirestore.instance
                      .collection('favCategory')
                      .doc(tmp['fa_no'])
                      .set(tmp);
                }
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
                child: const Text('Search'))
          ],
        ),
      ),
    );
  }
}

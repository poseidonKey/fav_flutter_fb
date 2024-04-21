import 'package:fav_flutter_fb/model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreenFirebase extends StatelessWidget {
  const SearchScreenFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Filtering Example'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
                'favData') // Replace 'your_collection' with your collection name
            .where('name', arrayContains: 'Coo')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Access the data and display it in your UI
              final data = snapshot.data!.docs[index].data() as DataModel;
              return ListTile(
                title: Text(data.name),
                // You can display other data fields here if needed
              );
            },
          );
        },
      ),
    );
  }
}

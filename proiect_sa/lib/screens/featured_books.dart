import 'package:flutter/material.dart';
import '../services/library_api.dart';

class FeaturedBooksScreen extends StatefulWidget {
  const FeaturedBooksScreen({super.key});

  @override
  State<FeaturedBooksScreen> createState() => _FeaturedBooksScreenState();
}

class _FeaturedBooksScreenState extends State<FeaturedBooksScreen> {
  final api = LibraryApi();
  late Future<List<String>> future;

  @override
  void initState() {
    super.initState();
    future = api.featured();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Featured")),
      body: FutureBuilder<List<String>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text("Error: ${snap.error}"));

          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text("No featured books"));
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => ListTile(title: Text(items[i])),
          );
        },
      ),
    );
  }
}

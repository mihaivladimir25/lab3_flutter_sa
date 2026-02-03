import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/library_api.dart';
import 'book_form.dart';

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({super.key});

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final api = LibraryApi();
  late Future<List<Book>> future;

  @override
  void initState() {
    super.initState();
    future = api.getAll();
  }

  void refresh() => setState(() => future = api.getAll());

  void msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> showAiSummary(Book b) async {
    if (b.id == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    try {
      final summary = await api.aiSummary(b.id!);

      if (!mounted) return;
      Navigator.pop(context); // close loading

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("AI Summary"),
          content: SingleChildScrollView(
            child: Text(summary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loading
      msg("AI error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Books")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookFormScreen()),
          );
          refresh();
        },
      ),
      body: FutureBuilder<List<Book>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text("Error: ${snap.error}"));

          final books = snap.data ?? [];
          if (books.isEmpty) return const Center(child: Text("No books"));

          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final b = books[i];

              return ListTile(
                title: Text(b.title),
                subtitle: Text("${b.author} • ${b.price.toStringAsFixed(2)}"),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BookFormScreen(book: b)),
                  );
                  refresh();
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "AI Summary",
                      icon: const Icon(Icons.auto_awesome),
                      onPressed: () => showAiSummary(b),
                    ),
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (b.id == null) return;
                        await api.delete(b.id!);
                        msg("Deleted");
                        refresh();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

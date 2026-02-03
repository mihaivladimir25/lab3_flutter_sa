import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/library_api.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book;
  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final api = LibraryApi();
  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    if (b != null) {
      titleCtrl.text = b.title;
      authorCtrl.text = b.author;
      priceCtrl.text = b.price.toString();
    }
  }

  void msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> save() async {
    final title = titleCtrl.text.trim();
    final author = authorCtrl.text.trim();
    final price = double.tryParse(priceCtrl.text.trim());

    if (title.isEmpty || author.isEmpty || price == null || price < 0) {
      msg("Completează corect câmpurile");
      return;
    }

    final payload = Book(id: widget.book?.id, title: title, author: author, price: price);

    if (widget.book == null) {
      await api.create(payload);
      msg("Created");
    } else {
      await api.update(widget.book!.id!, payload);
      msg("Updated");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Book" : "Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 12),
            TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: "Author")),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: save, child: Text(isEdit ? "Update" : "Create")),
            ),
          ],
        ),
      ),
    );
  }
}

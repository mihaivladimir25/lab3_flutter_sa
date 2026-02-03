import 'package:flutter/material.dart';
import 'screens/book_list.dart';
import 'screens/featured_books.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [BooksListScreen(), FeaturedBooksScreen()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: pages[idx],
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (v) => setState(() => idx = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.book), label: "Books"),
            NavigationDestination(icon: Icon(Icons.star), label: "Featured"),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class LibraryApi {
  // Flutter WEB -> backend local
  final String baseUrl = "http://localhost:8080/api/books";

  Future<List<Book>> getAll() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode != 200) throw Exception("GET /api/books failed");
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<Book> create(Book book) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("POST /api/books failed");
    }
    return Book.fromJson(jsonDecode(res.body));
  }

  Future<Book> update(int id, Book book) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );
    if (res.statusCode != 200) throw Exception("PUT /api/books/$id failed");
    return Book.fromJson(jsonDecode(res.body));
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("DELETE /api/books/$id failed");
    }
  }

  Future<List<String>> featured() async {
    final res = await http.get(Uri.parse("$baseUrl/featured"));
    if (res.statusCode != 200) throw Exception("GET /api/books/featured failed");
    final data = jsonDecode(res.body) as List;
    return data.map((e) => e.toString()).toList();
  }
}

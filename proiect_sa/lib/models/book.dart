class Book {
  final int? id;
  final String title;
  final String author;
  final double price;

  Book({this.id, required this.title, required this.author, required this.price});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: (json["id"] as num?)?.toInt(),
    title: json["title"] ?? "",
    author: json["author"] ?? "",
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "price": price,
  };
}

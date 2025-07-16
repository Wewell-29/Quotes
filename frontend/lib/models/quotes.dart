class Quote {
  final String id;
  final String text;
  final String author;
  final String category;
  bool isFavorite;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    this.isFavorite = false,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json['_id'],
        text: json['text'],
        author: json['author'],
        category: json['category'],
        isFavorite: json['isFavorite'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'author': author,
        'category': category,
        'isFavorite': isFavorite,
      };
}

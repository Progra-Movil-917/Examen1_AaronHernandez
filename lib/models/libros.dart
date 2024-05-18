class Libro {
  final int id;
  final int year;
  final String title;
  final String handle;
  final String publisher;
  final String isbn;
  final int pages;
  final List<String> notes;
  final DateTime createdAt;
  final List<Villano> villains;

  Libro({
    required this.id,
    required this.year,
    required this.title,
    required this.handle,
    required this.publisher,
    required this.isbn,
    required this.pages,
    required this.notes,
    required this.createdAt,
    required this.villains,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    List<dynamic> villainsData = json['villains'] ?? [];
    List<Villano> villains = villainsData.map((villainJson) => Villano.fromJson(villainJson)).toList();

    return Libro(
      id: json['id'],
      year: json['Year'],
      title: json['Title'],
      handle: json['handle'],
      publisher: json['Publisher'],
      isbn: json['ISBN'],
      pages: json['Pages'],
      notes: List<String>.from(json['Notes'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      villains: villains,
    );
  }
}

class Villano {
  final String name;
  final String url;

  Villano({
    required this.name,
    required this.url,
  });

  factory Villano.fromJson(Map<String, dynamic> json) {
    return Villano(
      name: json['name'],
      url: json['url'],
    );
  }
}

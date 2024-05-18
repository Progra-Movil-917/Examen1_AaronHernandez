class Villano {
  final String name;
  final String url;

  Villano({required this.name, required this.url});

  factory Villano.fromJson(Map<String, dynamic> json) {
    return Villano(
      name: json['name'],
      url: json['url'],
    );
  }
}

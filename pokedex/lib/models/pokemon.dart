class Pokemon {
  int id;
  String name;
  String url = "";
  bool isCaptured;
  int? gen;
  String type1;
  String? type2;

  Pokemon({
    required this.id,
    required this.name,
    required this.isCaptured,
    this.gen,
    required this.type1,
    this.type2,
  }) {
    url = "https://pokeapi.co/api/v2/pokemon/$id";
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      isCaptured: (json['isCaptured'] as int) == 1,
      gen: json['gen'] as int?,
      type1: json['type1'] as String,
      type2: json['type2'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isCaptured': isCaptured ? 1 : 0,
      'gen': gen,
      'type1': type1,
      'type2': type2,
    };
  }
}
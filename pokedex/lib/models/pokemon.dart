class Pokemon {
  late int id;
  final String name;
  final String url;

  Pokemon({
    required this.name,
    required this.url,
  }) {
    id = getId(url);
  }

  int getId(String url) {
    if (url.isNotEmpty) {
      url = url.substring(0, url.length - 1);
    }
    int lastIndex = url.lastIndexOf('/');

    if (lastIndex >= 0) {
      String numberStr = url.substring(lastIndex + 1);


      try {
        id = int.parse(numberStr);
        return id;

      } catch (error) {
        print("ERROR: $error");
        throw Exception("Id encontrado invalido para pokemon con url: $url");
      }
    } else {
      print("Url invalido");
      throw Exception("Url invalido recibido para pokemon con url: $url");
    }
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        name: json['name'] as String,
        url: json['url'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }
}
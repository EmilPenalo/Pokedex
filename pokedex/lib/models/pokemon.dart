import 'dart:convert';
import 'package:http/http.dart' as http;

class Pokemon {
  late int id;
  final String name;
  final String url;
  bool isCaptured;
  late List<String> types = [];

  Pokemon({
    required this.name,
    required this.url,
    required this.isCaptured,
  }) {
    id = getId(url);
    fetchTypes();
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

  Future<void> fetchTypes() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      types = (data['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to load types');
    }
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        name: json['name'] as String,
        url: json['url'] as String,
        isCaptured: (json['isCaptured'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isCaptured': isCaptured ? 1 : 0,
      'types': types
    };
  }
}
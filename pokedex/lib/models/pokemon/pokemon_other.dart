import 'package:pokedex/models/pokemon/pokemon_official_artwork.dart';

class Other {
  final OfficialArtwork officialArtwork;

  const Other({
    required this.officialArtwork,
  });

  factory Other.fromJson(Map<String, dynamic> json) {
    OfficialArtwork officialArtwork = OfficialArtwork.fromJson(json['official-artwork'] as Map<String, dynamic>);

    return Other(
        officialArtwork: officialArtwork
    );
  }
}
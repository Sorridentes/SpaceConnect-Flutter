/// Modelo de domínio para dados astronômicos da NASA APOD.
/// Equivalente ao Astronomy.kt do projeto Kotlin.
class AstronomyModel {
  final String date;
  final String title;
  final String description;
  final String image;
  final String? hdImage;
  final String? copyright;
  final String mediaType;
  bool isFavorite;

  AstronomyModel({
    required this.date,
    required this.title,
    required this.description,
    required this.image,
    this.hdImage,
    this.copyright,
    this.mediaType = 'image',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'description': description,
      'image': image,
      'hdImage': hdImage,
      'copyright': copyright,
      'mediaType': mediaType,
      'isFavorite': isFavorite,
    };
  }

  factory AstronomyModel.fromMap(Map<String, dynamic> map) {
    return AstronomyModel(
      date: map['date'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? map['explanation'] ?? '',
      image: map['image'] ?? map['url'] ?? '',
      hdImage: map['hdImage'] ?? map['hdurl'],
      copyright: map['copyright'],
      mediaType: map['mediaType'] ?? map['media_type'] ?? 'image',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  /// Factory para converter resposta da API NASA APOD
  factory AstronomyModel.fromApiResponse(Map<String, dynamic> json) {
    return AstronomyModel(
      date: json['date'] ?? '',
      title: json['title'] ?? '',
      description: json['explanation'] ?? '',
      image: json['url'] ?? '',
      hdImage: json['hdurl'],
      copyright: json['copyright'],
      mediaType: json['media_type'] ?? 'image',
      isFavorite: false,
    );
  }

  AstronomyModel copyWith({bool? isFavorite}) {
    return AstronomyModel(
      date: date,
      title: title,
      description: description,
      image: image,
      hdImage: hdImage,
      copyright: copyright,
      mediaType: mediaType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

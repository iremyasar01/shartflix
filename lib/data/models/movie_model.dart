class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  bool isFavorite;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // API key'lerine göre düzeltme
    final String id = json['_id'] ?? json['id'] ?? '';
    final String title = json['Title'] ?? 'No Title';
    final String description = json['Plot'] ?? 'No Description';
    
    // Poster URL düzeltmesi
    String posterUrl = json['Poster'] ?? json['posterUrl'] ?? '';

    // HTTP -> HTTPS dönüşümü
    if (posterUrl.startsWith('http:')) {
      posterUrl = posterUrl.replaceFirst('http:', 'https:');
    }
    
    // Geçersiz URL kontrolü
    if (posterUrl.isEmpty || 
        posterUrl.contains('placehold.co') || 
        !Uri.parse(posterUrl).isAbsolute) {
      posterUrl = 'https://via.placeholder.com/400x600?text=No+Poster';
    }

    return MovieModel(
      id: id,
      title: title,
      description: description,
      posterUrl: posterUrl,
    );
  }
}
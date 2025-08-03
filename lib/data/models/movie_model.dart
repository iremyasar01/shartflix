class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  bool isFavorite;
  final String? year;
  final String? director;
  final String? actors;
  final String? production; 

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
     this.year,
     this.director,
  this.actors,
     this.production, 
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String posterUrl = json['Poster'] ?? json['posterUrl'] ?? '';
    
    if (posterUrl.startsWith('http:')) {
      posterUrl = posterUrl.replaceFirst('http:', 'https:');
    }
    
    if (posterUrl.isEmpty || 
        posterUrl.contains('placehold.co') || 
        !Uri.parse(posterUrl).isAbsolute) {
      posterUrl = 'https://via.placeholder.com/400x600?text=No+Poster';
    }

    return MovieModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['Title'] ?? 'No Title',
      description: json['Plot'] ?? 'No Description',
      posterUrl: posterUrl,
      year: json['Year'] ?? '',
      director: json['Director'] ?? '',
      actors: json['Actors'] ?? '',
      production: json['Production'] ?? 'Unknown Production', // Yeni eklenen alan
    );
  }
}
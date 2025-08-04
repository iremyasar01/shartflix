class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;
  final String year;
  final String director;
  final String actors;
  final String production; 

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.isFavorite,
    required this.year,
    required this.director,
    required this.actors,
    required this.production, 
  });
  
  
  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
    String? year,
    String? director,
    String? actors,
    String? production, 
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      director: director ?? this.director,
      actors: actors ?? this.actors,
      production: production ?? this.production, 
    );
  }
}
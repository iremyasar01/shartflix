class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.isFavorite,
  });
  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  //@override
 // List<Object?> get props => [id, title, description, posterUrl, isFavorite];
}

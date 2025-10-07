enum Category {
  movies,
  places,
  videogames,
}

extension CategoryLabel on Category {
  String get label {
    switch (this) {
      case Category.movies:
        return 'Movies';
      case Category.places:
        return 'Places';
      case Category.videogames:
        return 'Videogames';
    }
  }
}


// The objetive of the mapper is that its can transform 
// a model to a entity. That is to say, convert data from my
// datasource to my structure data defining on my rules(entity).
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity( MovieMovieDB moviedb ) => Movie(
    adult: moviedb.adult, 
    backdropPath: moviedb.backdropPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png', 
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(), 
    id: moviedb.id, 
    originalLanguage: moviedb.originalLanguage, 
    originalTitle: moviedb.originalTitle, 
    overview: moviedb.overview, 
    popularity: moviedb.popularity, 
    posterPath: moviedb.posterPath != '' 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png', 
    releaseDate: moviedb.releaseDate, 
    title: moviedb.title, 
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage, 
    voteCount: moviedb.voteCount,
  ); 

}
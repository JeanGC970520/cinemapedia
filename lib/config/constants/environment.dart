
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static String theMovieDBkey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API key';

}
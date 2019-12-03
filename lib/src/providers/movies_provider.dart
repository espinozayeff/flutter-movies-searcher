import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/src/models/casting_model.dart';
import 'package:movies_app/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey      = '1865f43a0549ca50d341dd9ab8b29f49';
  String _url         = 'api.themoviedb.org';
  String _language    = 'es-ES';

  int _popularPage    = 0;
  bool _loading       = false;

  List<Movie> _populars = new List();


  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularStreamController.stream;


  void disposeStreams() {
    _popularStreamController.close();
  }

  Future<List<Movie>> _getResponse(Uri uri) async {
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.movieProperties;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _getResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];
    _loading = true;

    _popularPage++;
    final url = Uri.https(_url,
                          '3/movie/popular', 
                          {
                            'api_key' : _apiKey,
                            'language': _language,
                            'page'    : _popularPage.toString()
                          }
                        );

    final response = await _getResponse(url);
    _populars.addAll(response);
    popularsSink(_populars);

    _loading = false;
    return response;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url,
                          '3/movie/$movieId/credits',
                          {'api_key'  : _apiKey,
                           'language' : _language});
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url,
                          '3/search/movie',
                          {
                            'api_key' : _apiKey,
                            'language': _language,
                            'query'   : query
                          });

    return await _getResponse(url);
  }
}

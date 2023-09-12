import 'dart:convert';

import 'package:flutter_movies/app/data/http/http_client.dart';
import 'package:flutter_movies/app/data/model/movies_model.dart';

abstract class IMoviesRepository {
  Future<List<Results>> getMoveis();
}

class MoviesRepository implements IMoviesRepository {
  final IHttpClient client;
  MoviesRepository({required this.client});

  @override
  Future<List<Results>> getMoveis() async {
    final headers = {
      "X-RapidAPI-Key": "75584f818fmshc56356d380e37fep1ab359jsnd714f721113e",
      "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com",
    };
    final response = await client.get(
        url: "https://moviesdatabase.p.rapidapi.com/titles", headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> results = responseData['results'];

      return results.map((data) => Results.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

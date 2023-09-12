import 'package:flutter/material.dart';
import 'package:flutter_movies/app/data/http/exception.dart';
import 'package:flutter_movies/app/data/model/movies_model.dart';
import 'package:flutter_movies/app/data/repository/moveis_repository.dart';

class MoveisStore {
  final IMoviesRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Results>> state = ValueNotifier<List<Results>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  MoveisStore({required this.repository});

  Future getMovies() async {
    isLoading.value = true;

    try {
      final result = await repository.getMoveis();
      state.value = result;
    } on NotFoundExpection catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }
}

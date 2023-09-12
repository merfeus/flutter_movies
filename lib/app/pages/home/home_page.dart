import 'package:flutter/material.dart';
import 'package:flutter_movies/app/data/repository/moveis_repository.dart';
import 'package:flutter_movies/app/pages/home/store/moveis_store.dart';
import 'package:flutter_movies/app/data/http/http_client.dart';

import 'image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MoveisStore store = MoveisStore(
    repository: MoviesRepository(
      client: Http(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Lista de Filmes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
          animation: Listenable.merge([
            store.isLoading,
            store.error,
            store.state,
          ]),
          builder: (context, child) {
            if (store.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (store.error.value.isNotEmpty) {
              return Center(
                child: Text(
                  store.error.value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (store.state.value.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum item na lista',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 32,
                ),
                padding: const EdgeInsets.all(8),
                itemCount: store.state.value.length,
                itemBuilder: (_, index) {
                  final item = store.state.value[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ImageDetailPage(
                                  imageUrl: item.primaryImage?.url ?? ""),
                            ),
                          );
                        },
                        child: Image.network(
                          item.primaryImage?.url ??
                              "https://t3.ftcdn.net/jpg/04/34/72/82/240_F_434728286_OWQQvAFoXZLdGHlObozsolNeuSxhpr84.jpg",
                          width: 120,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Titulo do filme: ${item.titleText?.text ?? "N/A"}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                  "Ano de lançamento: ${item.releaseYear?.year?.toString() ?? "N/A"}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }),
    );
  }
}

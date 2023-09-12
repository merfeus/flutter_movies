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

  Future<void> _refreshData() async {
    await store.getMovies();
  }

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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: AnimatedBuilder(
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
                  return const Center(
                    child: Text(
                      'Erro ao carregar os filmes',
                      style: TextStyle(
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
                              if (item.primaryImage?.url != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ImageDetailPage(
                                        imageUrl: item.primaryImage!.url!),
                                  ),
                                );
                              } else {
                                // Se a URL da imagem for nula ou vazia, você pode exibir uma imagem de substituição ou mostrar uma mensagem de erro.
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Erro"),
                                      content:
                                          Text("A imagem não está disponível."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Fechar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
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
        ));
  }
}

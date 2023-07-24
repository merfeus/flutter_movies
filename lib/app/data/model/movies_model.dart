class MovieData {
  final int page;
  final String next;
  final int entries;
  final List<MovieResult> results;

  MovieData({
    required this.page,
    required this.next,
    required this.entries,
    required this.results,
  });

  factory MovieData.fromJson(Map<String, dynamic> map) {
    return MovieData(
      page: map['page'],
      next: map['next'],
      entries: map['entries'],
      results: List<MovieResult>.from(
        map['results'].map((result) => MovieResult.fromJson(result)),
      ),
    );
  }
}

class MovieResult {
  final String id;
  final String imageUrl;
  final String title;

  MovieResult({
    required this.id,
    required this.imageUrl,
    required this.title,
  });

  factory MovieResult.fromJson(Map<String, dynamic> map) {
    return MovieResult(
      id: map['id'],
      imageUrl: map['primaryImage']['url'],
      title: map['titleText']['text'],
    );
  }
}

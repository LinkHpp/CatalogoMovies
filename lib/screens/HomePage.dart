import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:animate_do/animate_do.dart';
import 'detalle_pelicula.dart';
import 'package:prac_hpp/entity/peli.dart';

class NowAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: const Row(
        children: [
          Icon(Icons.star),
          SizedBox(width: 8.0),
          Text(
            'Ya disponibles',
            style: TextStyle(fontSize: 16.0),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomePage> {
  List<Peli> nowPlayingMovies = [];
  List<Peli> upcomingMovies = [];

  final String apiKey = '1afdab0d288bc5bf29431c2a4c0792d6';
  final String language = 'es-ES';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/';

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
  }

  Future<void> _fetchNowPlayingMovies() async {
    try {
      final Response response = await Dio().get(
        '$baseUrl/now_playing',
        queryParameters: {'api_key': apiKey, 'language': language, 'page': 1},
      );

      setState(() {
        nowPlayingMovies = _mapMovies(response.data['results']);
      });
    } catch (error) {
      print('Error fetching now playing movies: $error');
    }
  }

  Future<void> _fetchUpcomingMovies() async {
    try {
      final Response response = await Dio().get(
        '$baseUrl/upcoming',
        queryParameters: {'api_key': apiKey, 'language': language, 'page': 1},
      );

      setState(() {
        upcomingMovies = _mapMovies(response.data['results']);
      });
    } catch (error) {
      print('Error fetching upcoming movies: $error');
    }
  }

  List<Peli> _mapMovies(List<dynamic> moviesData) {
    return moviesData.map((data) {
      return Peli(
        adult: data['adult'] ?? false,
        backdropPath: data['backdrop_path'] ?? '',
        genreIds: List<int>.from(data['genre_ids'] ?? []),
        id: data['id'] ?? 0,
        originalLanguage: data['original_language'] ?? '',
        originalTitle: data['original_title'] ?? '',
        overview: data['overview'] ?? '',
        popularity: data['popularity'] ?? 0.0,
        posterPath: data['poster_path'] ?? '',
        releaseDate: data['release_date'] ?? '',
        title: data['title'] ?? '',
        video: data['video'] ?? false,
        voteAverage: data['vote_average']?.toDouble() ?? 0.0,
        voteCount: data['vote_count'] ?? 0,
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Column(
        children: [
          NowAvailable(),
          SizedBox(height: 8.0),
          // Swiper con películas en cartelera
          Container(
            height: 200.0,
            child: Swiper(
              itemCount: nowPlayingMovies.length,
              itemBuilder: (BuildContext context, int index) {
                final peli = nowPlayingMovies[index];
                return SlideInUp(
                  duration: Duration(milliseconds: 500), // Ajusta la duración de la animación según tu preferencia
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePeliculaScreen(pelicula: peli),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w780${peli.backdropPath}',
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              viewportFraction: 0.8,
              scale: 0.8,
              autoplay: true,
              pagination: SwiperPagination(), // Progress dots
            ),
          ),
          SizedBox(height: 100),
          // ListView horizontal con películas de estreno próximo
          Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingMovies.length,
                itemBuilder: (BuildContext context, int index) {
                  final peli = upcomingMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePeliculaScreen(pelicula: peli),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: FadeInUp(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w300${peli.posterPath}',
                            width: 100.0,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

          ),
        ],
      ),
    );
  }
}

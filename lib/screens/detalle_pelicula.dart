import 'package:flutter/material.dart';
import '../entity/peli.dart';

class DetallePeliculaScreen extends StatefulWidget {
  final Peli pelicula;

  DetallePeliculaScreen({required this.pelicula});

  @override
  _DetallePeliculaScreenState createState() => _DetallePeliculaScreenState();
}

class _DetallePeliculaScreenState extends State<DetallePeliculaScreen> {
  bool mostrarTituloOriginal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mostrarTituloOriginal ? widget.pelicula.originalTitle : widget.pelicula.title),
        actions: [
          Switch(
            value: mostrarTituloOriginal,
            onChanged: (value) {
              setState(() {
                mostrarTituloOriginal = value;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 16.0),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              'https://image.tmdb.org/t/p/w780${widget.pelicula.backdropPath}',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Fecha de Estreno: ${_formatReleaseDate(widget.pelicula.releaseDate)}',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          LinearProgressIndicator(
            value: widget.pelicula.voteAverage / 10,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 8.0),
          Text(
            'Valoración: ${widget.pelicula.voteAverage}/10',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            mostrarTituloOriginal ? 'Título Original: ${widget.pelicula.originalTitle}' : 'Título: ${widget.pelicula.title}',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'Sinopsis: ${widget.pelicula.overview}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    DateTime parsedDate = DateTime.parse(releaseDate);
    return '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';
  }
}

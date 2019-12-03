import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {

  String selectedMovie = '';
  final moviesProvider = new MoviesProvider();

  final movies = [
    'Spiderman',
    'Batman',
    'Superman',
    'Capitán América'
  ];

  final recentMovies = [
    'Spiderman',
    'Capitán América'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    /*
      Acciones del AppBar, por ejemplo, un botón para cancelar
     o limpiar el campo de búsqueda
    */
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    /* 
      Ícono a la izquieda del aapBar, como el ícono de búsqueda o
      el ícono de regreso
     */
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /* 
      Construye, crea, los resultados a mostrar
    */

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /* 
      Son las sugerencias que aparecen cuando el usuario escribe
    */
    if (query.isEmpty) {
      return Container();
    } 

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context,
                AsyncSnapshot<List<Movie>> snapshot) {
        if(snapshot.hasData) {
          final movies = snapshot.data;
           return ListView(
             children: movies.map((movie){
               return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/img/loading.jpg'),
                    width: 50,
                    fit: BoxFit.contain
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context,
                                     'detalle',
                                      arguments: movie
                                      );
                },
               );
             }).toList(),
           );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }

}
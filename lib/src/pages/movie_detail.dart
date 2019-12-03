import 'package:flutter/material.dart';
import 'package:movies_app/src/models/casting_model.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 25),
                _createPosterTitle(context, movie),
                _writeMovieOverview(movie.overview),
                SizedBox(height: 10),
                _createCasting(movie.id),
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _createAppBar(Movie movie) =>
    SliverAppBar(
      elevation: 5,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 250,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getbackdropPathImg()),
          placeholder: AssetImage('assets/img/loading.jpg'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );

  Widget _createPosterTitle(BuildContext context, Movie movie) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150,
              ),
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );

  Widget _writeMovieOverview(String overview) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20,
                                    vertical: 30),
      child: Text(overview),
    );

  Widget _createCasting(int movieId) {
    final movieProvider = new MoviesProvider();
    
    return FutureBuilder(
      future: movieProvider.getCast(movieId.toString()),
      builder: (BuildContext context,
                AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData) {
          return _createCastPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createCastPageView(List<Actor> cast) =>
    SizedBox(
      height: 150,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.23,
          initialPage: 1),
        itemCount: cast.length,
        itemBuilder: (context, i) => _createActorCard(cast[i])
      ),
    );

  Widget _createActorCard(Actor actor) =>
    Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(actor.getActorPhoto()),
                placeholder: AssetImage('assets/img/loading.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
}




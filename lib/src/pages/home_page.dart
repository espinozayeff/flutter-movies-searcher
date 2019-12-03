import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/search/search_delegate.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {

    moviesProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas de cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch( context: context,
                          delegate: DataSearch());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() => FutureBuilder(
        future: moviesProvider.getNowPlaying(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(movies: snapshot.data);
          } else {
            return Container(
                height: 300, child: Center(child: CircularProgressIndicator()));
          }
        },
      );

  Widget _footer(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Text('Populares', style: Theme.of(context).textTheme.subhead),
            SizedBox(height: 15),

            StreamBuilder(
              stream: moviesProvider.popularsStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return (snapshot.hasData)
                    ? MovieHorizontal(movies: snapshot.data,
                                      nextPage: moviesProvider.getPopular,)
                    : CircularProgressIndicator();
              },
            )
          ],
        ),
      );
}

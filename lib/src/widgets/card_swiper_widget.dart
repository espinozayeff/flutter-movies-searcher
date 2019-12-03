import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 15), 
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          movies[index].uniqueId = '${movies[index].id}-cards';

          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context,
                                                'detalle',
                                                arguments: movies[index]),
                child: FadeInImage(
                  image: NetworkImage(movies[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

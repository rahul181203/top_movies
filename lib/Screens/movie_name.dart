import 'package:flutter/material.dart';
import 'package:top_movies/Network/movie_data.dart';
import 'list_movies.dart';

class AddMovie extends StatelessWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String newMovieName;
    List<Map<String, String>> listMovies = [];

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add Movie',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newMovieName = newText;
              },
            ),
            FlatButton(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () async {
                var movie = await MovieData().getMoviedata(newMovieName);
                for (int i = 0; i < movie.length; i++) {
                  var movies = {
                    "nameOfMovie":
                        "${movie[i]['title']}-${movie[i]['release_date'].split("-")[0]}-${movie[i]['original_language']}",
                    "movieID": "${movie[i]['id']}",
                  };
                  listMovies.add(movies);
                }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListMovies(
                        movieName: listMovies,
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

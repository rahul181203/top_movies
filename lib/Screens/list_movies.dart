import 'package:flutter/material.dart';
import 'package:top_movies/Screens/movie_screen.dart';
import '../Network/movie_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class ListMovies extends StatefulWidget {
  final List<Map<String, String>> movieName;
  ListMovies({required this.movieName});
  @override
  _ListMoviesState createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(22),
              child: Text(
                'List Of Movies',
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ),
            for (int i = 0; i < widget.movieName.length; i++)
              MovieNames(widget.movieName[i]['nameOfMovie'].toString(),
                  widget.movieName[i]['movieID'].toString())
          ],
        ),
      ),
    );
  }
}

class MovieNames extends StatelessWidget {
  MovieNames(this.name, this.id);
  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    String title;
    String overview;
    String releaseDate;
    String poster;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: [
            FlatButton(
                onPressed: () async {
                  var data = await MovieData().getData(id);
                  title = data['title'];
                  overview = data['overview'];
                  poster = data['poster_path'];
                  releaseDate = data['release_date'].split("-")[0];
                  _firestore.collection('movieList').add({
                    "title":title,
                    "overview":overview,
                    "poster":poster,
                    "releaseDate":releaseDate,
                    "a":DateTime.now(),
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieScreen(),
                    ),
                  );
                },
                child: Text(name))
          ],
        ),
      ),
    );
  }
}

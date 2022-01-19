import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../const.dart';
import 'movie_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  String title = '';
  String overview = '';
  String poster = '';
  String releaseData = '';
  String docID = "";
  List<MoviesList> listOfMovies = [];
  @override
  void initState() {
    _fireStore.collection('movieList').get().then((querySnapshot) => {
      querySnapshot.docs.forEach((document) {
        setState(() {
          docID = document.id;
          title = document['title'];
          overview = document['overview'];
          poster = document['poster'];
          releaseData = document['releaseDate'];
        });
        var list = MoviesList(title: title, overview: overview, poster: poster, releaseData: releaseData, docID: docID);
        listOfMovies.add(list);
      })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY FAV MOVIES'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              listOfMovies=[];
            });
            initState();
            },
          child: ListView(
            children: [
              for (int i=0; i<listOfMovies.length; i++)
                listOfMovies[i],
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 30),
                child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const AddMovie(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoviesList extends StatefulWidget {
  MoviesList({required this.title,required this.overview,required this.poster,required this.releaseData, required this.docID});
  final String title;
  final String overview;
  final String poster;
  final String releaseData;
  final String docID;

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Expanded(
        child: FlipCard(
          front: Container(
              decoration: flipDecoration,
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.all(30),
              child: Image.network('$movie_img${widget.poster}')
          ),
          back: Container(
            decoration: flipDecoration,
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text("${widget.title} (${widget.releaseData})"),
                Text(widget.overview),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _fireStore.collection('movieList')
                          .doc(widget.docID)
                          .delete();
                    });
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
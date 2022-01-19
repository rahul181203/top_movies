import 'get_movie_data.dart';
import '../const.dart';

class MovieData {
  Future<dynamic> getMoviedata(String newMovie) async {
    Network network = Network(url: "$api_url?query=$newMovie&api_key=$api_key");
    var data = await network.getData();
    return data['results'];
    }

  Future<dynamic> getData(String id) async {
    Network network = Network(url: "$api_movie/$id?api_key=$api_key");
    var data = await network.getData();
    return data;
  }
  }


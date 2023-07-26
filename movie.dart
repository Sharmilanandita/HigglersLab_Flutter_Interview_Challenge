class Movie
{
  int? movie_id;
  String? movie_title;
  int? movie_releaseyear;
  double? movie_rating;
  String? movie_genre;
  String? movie_director;
  String? movie_information;
  String? movie_image;

  Movie({
    this.movie_id,
    this.movie_title,
    this.movie_releaseyear,
    this.movie_rating,
    this.movie_genre,
    this.movie_director,
    this.movie_information,
    this.movie_image,
    });
  factory Movie.fromJson(Map<String,dynamic> json)=>Movie(
    movie_id: int.parse(json["movie_id"]),
    movie_title:json["movie_title"],
    movie_releaseyear:int.parse(json["movie_releaseyear"]),
    movie_rating:double.parse(json["movie_rating"]),
    movie_genre: json["movie_genre"],
    movie_director: json["movie_director"],
    movie_information: json["movie_information"],
    movie_image: json["movie_image"],
  );
}
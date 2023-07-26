<?php
include '../connection.php';


$movieTitle = $_POST['movie_title'];
$movieReleaseyear = $_POST['movie_releaseyear'];
$movieRating = $_POST['movie_rating'];
$movieGenre = $_POST['movie_genre'];
$movieDirector = $_POST['movie_director'];
$movieInformation = $_POST['movie_information'];
$movieImage = $_POST['movie_image'];

$sqlQuery = "INSERT INTO movie_tables SET movie_title = '$movieTitle', movie_releaseyear = '$movieReleaseyear', movie_rating = '$movieRating', movie_genre = '$movieGenre', movie_director = '$movieDirector', movie_information = '$movieInformation', movie_image = '$movieImage'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}
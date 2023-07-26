<?php
include '../connection.php';



$sqlQuery = "SELECT * FROM movie_tables ORDER BY movie_id DESC";
$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows>0)
{
    $movieItemsRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $movieItemsRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success"=>true,
            "movieItemsData"=>$movieItemsRecord,
            )
    );
}
else
{
    echo json_encode(array("success"=>false));
}
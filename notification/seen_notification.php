<?php

require_once 'NotificationFunctions.php';
include_once (__DIR__ .  '/../util/UtilFunctions.php');

$func = new NotificationFunctions();
$util = new UtilFunctions();

 
// json response array
$response = array("isSession" => true,
              "error" => false);
 
 
if (isset($_POST['username']) && isset($_POST['sessionId']) && isset($_POST['notifyId'])) {
	
    $username = $_POST['username'];
	$sessionId = $_POST['sessionId'];
    $notifyId = $_POST['notifyId'];
    
    if($util->isActiveSession($username,$sessionId)) {
        
      $notify = $func->seenNotification($username, $notifyId);
      
      if($notify != OPERATION_FAILED) {
           
        $response["message"] = "Notification seen succesfully";
        $response["data"] = array ('notifyId' => $notifyId);
     
      }else {
   
        $response["error"] = true;
        $response["message"] = "Unable to seen notification";
 
      }
        
    } else {
       $response["isSession"] = false;
       $response["error"] = true;
       $response["message"] = "Session expired"; 
    }
            
    echo json_encode($response);
	
}else {
    echo 'ERROR! missing param';
}
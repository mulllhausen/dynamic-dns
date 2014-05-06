<?php

//receive the server's external ip address and store it in a file to be replayed
//later

$ip = trim($_GET["ip"]);
if($ip)
{
	//the user is attempting to update the ip address

	//sanitize ip address
	if(!preg_match("/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/", $ip))
	{
		$now = date("Y-m-d h:i:s");
		file_put_contents
		(
			"/tmp/intermediary_ip.log",
			"[$now] bad ip address received: $ip", FILE_APPEND
		);
		exit;
	}
	//ip address is safe - save it for later
	$previous_ip = file_get_contents("/tmp/intermediary_ip.txt");
	if($previous_ip != $ip)
	{
		file_put_contents
		(
			"/tmp/intermediary_ip.log",	"[$now] updated ip address: $ip",
			FILE_APPEND
		);
		file_put_contents("/tmp/intermediary_ip.txt", $ip); //overwrite
	}
}
if(isset($_GET["retrieve"]))
{
	if(!strlen($ip)) $ip = file_get_contents("/tmp/intermediary_ip.txt");
	echo $ip;
}

?>

<?php

//version 1.0

//receive the server's hmac and external ip address

$salts_file = "/tmp/mulll-dynamic-dns-intermediary-salts";
$external_ip_file = "/tmp/mulll-dynamic-dns-server-ip-address";

$now = time();
// change this password otherwise anybody will be able to set your server's ip
// address. make sure to also change it in files server.sh and client.sh
$pw = "a long string of random characters $%^$%^(f@S!<>";

switch($_GET["action"])
{
	case "update":
		validate_querystring(); //die upon fail
		$server_ip = trim($_SERVER["REMOTE_ADDR"]);
		echo $server_ip;
		if(!preg_match("/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/", $server_ip))
		{
			die("bad ip address $server_ip");
		}
		//if we make it here then its safe to save the received data
		file_put_contents($external_ip_file, $server_ip);
		update_used_salts($_GET["salt"]);
		break;
	case "retrieve":
		validate_querystring(); //die upon fail
		echo file_get_contents($external_ip_file);
		break;
}
function validate_querystring()
{
	global $now, $pw;
	if(!isset($_GET["salt"]) || !strlen($_GET["salt"]))
	{
		die("no salt specified");
	}
	if(!isset($_GET["hash"]) || !strlen($_GET["hash"]))
	{
		die("no hash specified");
	}
	if(abs($now - $_GET["salt"]) > 30)
	{
		die("salt (".$_GET["salt"].") out of range");
	}
	if(salt_already_used($_GET["salt"])) die("salt already used");
	if(sha1($_GET["salt"].$pw) != $_GET["hash"]) die("bad hash");
}
function salt_already_used($salt)
{
	global $salts_file;
	$used_salts_str = file_get_contents($salts_file);
	if(strstr($user_salts_str, $salt)) return true; //found
	return false; //not found
}
function update_used_salts($salt)
{
	global $salts_file, $now;
	$salts_file_str = file_get_contents($salts_file);
	$salts_file_arr = explode("\n", $salts_file_str);
	$new_salts_arr = array($salt); //will be saved to the $salts_file
	foreach($salts_file_arr as $salt_i)
	{
		if(!is_numeric($salt_i)) continue;
		if($salt_i == $salt) continue; //salt already exists in array
		if(abs($now - $salt_i) > 30) continue; //this salt is too old
		$new_salts_arr[] = $salt_i;
	}
	file_put_contents($salts_file, implode("\n", $new_salts_arr)); //overwrite
}

?>

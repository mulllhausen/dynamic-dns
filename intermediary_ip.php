<?php

//receive the server's hmac and external ip address

$salts_file = "/tmp/external_ip_salts.txt";
$external_ip_file = "/tmp/external_ip_address.txt";

$now = time();
$pw = "a long string of random characters $%^$%^(f@S!<>";

switch($_GET["action"])
{
	case "update":
		$salt = $_GET["salt"];
		$hash = $_GET["hash"];
		if(!strlen($salt)) die("no salt specified");
		if(!strlen($hash)) die("no hash specified");
		if(abs($now - $salt) > 10) die("salt ($salt) out of range");
		if(salt_already_used($salt)) die("salt already used");
		if(sha1("$salt$pw") != $hash) die("bad hash");
		$server_ip = trim($_SERVER["REMOTE_ADDR"]);
		echo "your server ip: $server_ip\n";
		if(!preg_match("/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/", $server_ip))
		{
			die("bad ip address $server_ip");
		}
		//if we make it here then its safe to save the received data
		file_put_contents($external_ip_file, $server_ip);
		update_used_salts($salt);
		break;
	case "retrieve":
		echo file_get_contents($external_ip_file);
		break;
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
		if(abs($now - $salt_i) > 10) continue; //this salt is too old
		$new_salts_arr[] = $salt_i;
	}
	file_put_contents($salts_file, implode("\n", $new_salts_arr)); //overwrite
}

?>

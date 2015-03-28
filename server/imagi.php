<?php
/* Usage:
 *  [GET] imagi.php?operation=entry&arg1=0&arg2=Entry%20One
 * A new line containing <operation>[ <arg1>[ <arg2>[ <arg3>]]]
 * will be appended to the end of memory.txt.
 * */

header('Access-Control-Allow-Origin: *');
date_default_timezone_set('Asia/Shanghai');

$fp = fopen('memory.txt', 'a');
$s = $_GET['operation'];
if (($arg = $_GET['arg1']) != null) $s .= ' ' . $arg;
if (($arg = $_GET['arg2']) != null) $s .= ' ' . $arg;
if (($arg = $_GET['arg3']) != null) $s .= ' ' . $arg;
fprintf($fp, "%s %s\n", date('Y-m-d-H-i-s'), $s);
fclose($fp); 

?>

<?php
/* Usage:
 *  [GET] memory.php
 * Retrieves the whole database with the Access-Control-Allow-Origin header.
 * */

header('Access-Control-Allow-Origin: *');
readfile('memory.txt');
?>

<?php

echo '<pre>';
$arr = array(1, 2, 3, 4);

foreach ($arr as &$value) {
    $value = $value * 2;
    print_r($arr);
}

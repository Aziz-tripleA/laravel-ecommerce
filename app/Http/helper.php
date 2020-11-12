<?php


if(!function_exists('adminURL')){

    function adminURL($url = null){

        return url('admin/'.$url);

    }
}
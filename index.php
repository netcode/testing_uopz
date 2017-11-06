<?php
if (version_compare(PHP_VERSION, '7.0.0') >= 0) {
	testPHP7();
}else{
	testPHP5();
}


function testPHP7()
{
	if(function_exists('uopz_set_hook')){
		echo 'uopz_set_hook exists => good';
	}else{
		throw new Exception("uopz_set_hook not exists", 1);
		
	}
}

function testPHP5()
{
	if(function_exists('uopz_rename')){
		echo 'uopz_rename exists => good';
	}else{
		throw new Exception("uopz_rename not exists", 1);
		
	}
}

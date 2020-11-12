<?php

/**
 * Email: aziz.adel.fci@gmail.com
 * User: aziz
 * Date: 11/8/20
 * Time: 1:14 AM
 */

use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\admin\AdminAuth;
/**
 * admin routes
 */
Route::group(['prefix' => 'admin'], function () {
    /** set default guard in config/auth file  */
    Config::set('auth.defaults', 'admin');
    /** login post & get  */
    Route::get('login', AdminAuth::class . '@getLogin')->name('admin.login');
    Route::post('login', AdminAuth::class . '@postLogin')->name('admin.login');
    /** reset admin password */
    Route::get('password/reset', AdminAuth::class . '@getResetPassword');
    Route::post('password/reset', AdminAuth::class . '@postResetPassword');
    
    Route::group(['middleware' => 'admin:admin'], function () {
        /** admin home route */
        Route::get('/', function () {
            return view('admin.home');
        })->name('admin.home');

        /** admin logout */
        Route::any('logout',AdminAuth::class.'@logout')->name('admin.logout');
    });
});

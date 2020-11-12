<?php

namespace App\Http\Controllers\admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Mail\AdminResetPassword;
use App\Models\Admin;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
class AdminAuth extends Controller
{
    /* public function __construct()
    {
        $this->middleware('guest')->except('logout');
        $this->middleware('guest:admin')->except('logout');
    } */

    /*** get login page */
    public function getLogin()
    {
        return view('admin.login');
    }
    /** do login */
    public function postLogin(Request $request)
    {
        $rememberMe = ($request->remember == 1 )? true : false ;
        if (Auth::guard('admin')->attempt(['email' => $request->email, 'password' => $request->password], $rememberMe)) {

            return redirect()->route('admin.home');
        }
        return back()->withInput($request->only('email', 'remember'));

    }
    /** logout func */
    public function logout()
    {
        auth()->guard('admin')->logout();
        return redirect()->route('admin.login');
    }
    /** get reset password page */
    public function getResetPassword()
    {
        return view('admin.reset_password')->with(['success'=>'success message']);
    }
    public function postResetPassword(Request $request)
    {
        $admin = Admin::where('email',$request->email)->first();
        
        if($admin){
            $token =  Str::random(60);    //app('auth.password.broker')->createToken($admin);
            $data = DB::table('password_resets')->insert([
                'email'=>$admin->email,
                'token'=>$token,
                'created_at'=>Carbon::now()
            ]);
            Mail::to($admin->email)->send(new AdminResetPassword(['data'=>$admin,'token'=>$token]));
            return back()->with(['success'=>'email sent successfully. go to your email']);
        }
        return back()->with(['fail'=>'email not found']);
    }
}

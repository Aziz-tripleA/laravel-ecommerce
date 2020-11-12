@component('mail::message')
# reset admin password
# hello {{ $data['data']->name}}


@component('mail::button', ['url' => adminURL('reset/password/'.$data['token'])])
click here to Reset your Password
@endcomponent

Thanks,<br>
{{ config('app.name') }}
@endcomponent

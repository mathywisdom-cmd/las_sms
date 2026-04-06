<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class SmsService
{
    public function send($phone, $message)
    {
        return Http::withHeaders([
            'apiKey' => env('SMS_API_KEY'),
        ])->asForm()->post('https://api.sandbox.africastalking.com/version1/messaging', [
            'username' => env('SMS_USERNAME'),
            'to' => $phone,
            'message' => $message,
        ]);
    }
}
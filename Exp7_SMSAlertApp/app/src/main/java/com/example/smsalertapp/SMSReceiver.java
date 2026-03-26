package com.example.smsalertapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.widget.Toast;

public class SMSReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        Bundle bundle = intent.getExtras();

        if (bundle != null) {

            Object[] pdus = (Object[]) bundle.get("pdus");
            String format = bundle.getString("format"); // ✅ IMPORTANT

            for (Object pdu : pdus) {

                SmsMessage sms;

                // ✅ Handle both old and new Android versions
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    sms = SmsMessage.createFromPdu((byte[]) pdu, format);
                } else {
                    sms = SmsMessage.createFromPdu((byte[]) pdu);
                }

                String sender = sms.getOriginatingAddress();
                String message = sms.getMessageBody();

                Toast.makeText(context,
                        "SMS from: " + sender + "\n" + message,
                        Toast.LENGTH_LONG).show();
            }
        }
    }
}
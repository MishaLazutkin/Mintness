package com.iowise.mintness;

import static com.iowise.mintness.MainActivity.methodChannel;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;
import android.widget.Toast;

import io.flutter.plugin.common.MethodChannel;


public class SmsReceiver extends BroadcastReceiver {
    private static final String TAG =
            SmsReceiver.class.getSimpleName();
    public static final String pdu_type = "pdus";
    private static final String SMS_RECEIVED = "android.provider.Telephony.SMS_RECEIVED";
    SmsMessage[] msgs;
    String message="";
    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "onReceive called: "  );
        if (intent != null && SMS_RECEIVED.equals(intent.getAction())) {
            message = extractSmsMessage(context,intent);
            processMessage(  message);
        }



    }
    @TargetApi(Build.VERSION_CODES.M)
    private String extractSmsMessage(Context context, final Intent intent) {
        Bundle bundle = intent.getExtras();
        Object[] pdus = (Object[]) bundle.get(pdu_type);
        String strMessage = "";
        String format = bundle.getString("format");
        // Retrieve the SMS message received.
        if (pdus != null) {
            // Check the Android version.
            boolean isVersionM =
                    (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M);
            // Fill the msgs array.
            msgs = new SmsMessage[pdus.length];
            for (int i = 0; i < msgs.length; i++) {
                // Check Android version and use appropriate createFromPdu.
                if (isVersionM) {
                    // If Android version M or newer:
                    msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i], format);
                } else {
                    // If Android version L or older:
                    msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
                }
                // Build the message to show.
                strMessage += "SMS from " + msgs[i].getOriginatingAddress();
                strMessage += " :" + msgs[i].getMessageBody() + "\n";
                Log.d(TAG, "onReceive: " + strMessage);
                //Toast.makeText(context, strMessage, Toast.LENGTH_LONG).show();
            }
        }
        return strMessage.split(":")[2];
    }

    private void processMessage(  final String smsMessage) {
        methodChannel.invokeMethod("SMSReceived", smsMessage );
    }
}
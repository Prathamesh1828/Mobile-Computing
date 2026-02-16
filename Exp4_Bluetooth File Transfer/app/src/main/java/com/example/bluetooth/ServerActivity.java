package com.example.bluetooth;

import android.bluetooth.*;
import android.os.Bundle;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.UUID;

public class ServerActivity extends AppCompatActivity {

    private static final UUID MY_UUID =
            UUID.fromString("fa87c0d0-afac-11de-8a39-0800200c9a66");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new Thread(() -> {
            try {
                BluetoothAdapter adapter =
                        BluetoothAdapter.getDefaultAdapter();

                BluetoothServerSocket serverSocket =
                        adapter.listenUsingRfcommWithServiceRecord(
                                "BluetoothFileTransfer",
                                MY_UUID);

                BluetoothSocket socket = serverSocket.accept();

                InputStream is = socket.getInputStream();
                FileOutputStream fos =
                        openFileOutput("received_file",
                                MODE_PRIVATE);

                byte[] buffer = new byte[1024];
                int bytes;

                while ((bytes = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytes);
                }

                fos.close();
                is.close();
                socket.close();
                serverSocket.close();

                runOnUiThread(() ->
                        Toast.makeText(this,
                                "File Received",
                                Toast.LENGTH_LONG).show());

            } catch (Exception e) {
                runOnUiThread(() ->
                        Toast.makeText(this,
                                "Receive Failed",
                                Toast.LENGTH_LONG).show());
            }
        }).start();
    }
}

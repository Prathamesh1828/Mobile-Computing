package com.example.bluetooth;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class MainActivity extends AppCompatActivity {

    private static final int FILE_REQUEST_CODE = 100;
    private static final int PERMISSION_REQUEST_CODE = 200;

    private Uri fileUri;
    private TextView tvStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvStatus = findViewById(R.id.tvStatus);
        Button btnSelect = findViewById(R.id.btnSelect);
        Button btnSend = findViewById(R.id.btnSend);

        checkPermissions();

        btnSelect.setOnClickListener(v -> selectFile());

        btnSend.setOnClickListener(v -> {
            if (fileUri != null) {
                sendFile();
            } else {
                Toast.makeText(this, "Please select a file first", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void checkPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (ContextCompat.checkSelfPermission(this,
                    Manifest.permission.BLUETOOTH_CONNECT)
                    != PackageManager.PERMISSION_GRANTED) {

                ActivityCompat.requestPermissions(this,
                        new String[]{
                                Manifest.permission.BLUETOOTH_CONNECT,
                                Manifest.permission.BLUETOOTH_SCAN
                        },
                        PERMISSION_REQUEST_CODE);
            }
        }
    }

    private void selectFile() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("*/*");
        startActivityForResult(Intent.createChooser(intent, "Select File"),
                FILE_REQUEST_CODE);
    }

    private void sendFile() {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_STREAM, fileUri);
        intent.setPackage("com.android.bluetooth");

        try {
            startActivity(Intent.createChooser(intent, "Send via"));
        } catch (Exception e) {
            Toast.makeText(this,
                    "Bluetooth not available on this device",
                    Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onActivityResult(int requestCode,
                                    int resultCode,
                                    Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == FILE_REQUEST_CODE &&
                resultCode == RESULT_OK &&
                data != null) {

            fileUri = data.getData();
            tvStatus.setText("File selected ✔");
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {

        super.onRequestPermissionsResult(requestCode,
                permissions, grantResults);

        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 &&
                    grantResults[0] != PackageManager.PERMISSION_GRANTED) {

                Toast.makeText(this,
                        "Bluetooth permission required",
                        Toast.LENGTH_SHORT).show();
            }
        }
    }
}

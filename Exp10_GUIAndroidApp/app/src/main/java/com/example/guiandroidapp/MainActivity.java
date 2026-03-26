package com.example.guiandroidapp;

import androidx.appcompat.app.AppCompatActivity;

import android.graphics.Color;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    TextView textView;
    Button btnSize, btnColor;

    float currentSize = 20f;
    boolean isRed = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        textView = findViewById(R.id.textView);
        btnSize = findViewById(R.id.btnSize);
        btnColor = findViewById(R.id.btnColor);

        btnSize.setOnClickListener(v -> {
            currentSize += 5;
            textView.setTextSize(currentSize);
        });

        btnColor.setOnClickListener(v -> {
            if (isRed) {
                textView.setTextColor(Color.BLUE);
            } else {
                textView.setTextColor(Color.RED);
            }
            isRed = !isRed;
        });
    }
}
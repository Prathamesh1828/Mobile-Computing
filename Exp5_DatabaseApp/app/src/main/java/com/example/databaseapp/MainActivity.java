package com.example.databaseapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    EditText name, age;
    Button save, view;
    DBHelper dbHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        name = findViewById(R.id.editName);
        age = findViewById(R.id.editAge);
        save = findViewById(R.id.btnSave);
        view = findViewById(R.id.btnView);

        dbHelper = new DBHelper(this);

        save.setOnClickListener(v -> {
            String n = name.getText().toString();
            int a = Integer.parseInt(age.getText().toString());

            dbHelper.insertData(n, a);
            Toast.makeText(this, "Data Saved", Toast.LENGTH_SHORT).show();
        });

        view.setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, ViewDataActivity.class);
            startActivity(intent);
        });
    }
}
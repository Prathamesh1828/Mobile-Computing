package com.example.databaseapp;

import androidx.appcompat.app.AppCompatActivity;

import android.database.Cursor;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.ArrayList;

public class ViewDataActivity extends AppCompatActivity {

    ListView listView;
    DBHelper dbHelper;
    ArrayList<String> list;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_data);

        listView = findViewById(R.id.listView);
        dbHelper = new DBHelper(this);

        Cursor cursor = dbHelper.getAllData();
        list = new ArrayList<>();

        while (cursor.moveToNext()) {
            list.add("Name: " + cursor.getString(0) +
                    " | Age: " + cursor.getInt(1));
        }

        ArrayAdapter<String> adapter =
                new ArrayAdapter<>(this,
                        android.R.layout.simple_list_item_1, list);

        listView.setAdapter(adapter);
    }
}
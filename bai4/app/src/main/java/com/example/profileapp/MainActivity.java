package com.example.profileapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Gắn file giao diện activity_main.xml vào màn hình
        setContentView(R.layout.activity_main);

        // Bước 1: Tìm các nút trong giao diện theo id
        Button btnFacebook = findViewById(R.id.btnFacebook);
        Button btnYoutube = findViewById(R.id.btnYoutube);
        Button btnGithub = findViewById(R.id.btnGithub);

        // Bước 2: Gắn sự kiện Click cho từng nút
        btnFacebook.setOnClickListener(v -> moLienKet("https://www.facebook.com"));
        btnYoutube.setOnClickListener(v -> moLienKet("https://www.youtube.com"));
        btnGithub.setOnClickListener(v -> moLienKet("https://github.com/HaiNinh1"));
    }

    // Bước 3: Dùng Intent để mở đường link
    private void moLienKet(String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        startActivity(intent);
    }
}

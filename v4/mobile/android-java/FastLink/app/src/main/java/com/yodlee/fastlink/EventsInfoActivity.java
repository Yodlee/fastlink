// Copyright (c) 2019 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

package com.yodlee.fastlink;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.util.ArrayList;

public class EventsInfoActivity extends AppCompatActivity {

    private Button logoutBtn;
    private Button linkAccountBtn;
    private TextView eventsInfoText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_events_info);

        ArrayList<String> eventsInfo = (ArrayList<String>) getIntent().getSerializableExtra("eventsInfo");

        Log.d("FL:MESSAGE", eventsInfo.toString());

        StringBuilder builder = new StringBuilder();
        for (String event : eventsInfo) {
            builder.append(event + "\n\n");
        }

        eventsInfoText = findViewById(R.id.eventsInfoText);
        eventsInfoText.setText(builder.toString());

        Log.d("FL:MESSAGE", builder.toString());

        logoutBtn = findViewById(R.id.logoutBtn);

        logoutBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                Intent intent = new Intent(view.getContext(), LoginActivity.class);
                startActivity(intent);
            }
        });
    }
}

// Copyright (c) 2019 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

package com.yodlee.fastlink;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.yodlee.fastlink.Config;

public class LoginActivity extends AppCompatActivity {

    private Button signInBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        final EditText fastlinkURLTextField = (EditText) findViewById(R.id.fastlinkURL);
        final EditText accessTokenTextField = (EditText) findViewById(R.id.accessToken);
        final EditText extraParamsTextField = (EditText) findViewById(R.id.extraParams);
        fastlinkURLTextField.setText(Config.fastlinkURL);

        signInBtn = findViewById(R.id.signInBtn);

        signInBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {

                String extraParams = extraParamsTextField.getText().toString();
                Intent intent = new Intent(view.getContext(), WebViewActivity.class);
                intent.putExtra("fastlinkURL", fastlinkURLTextField.getText().toString());
                intent.putExtra("accessToken", accessTokenTextField.getText().toString());
                intent.putExtra("extraParams", extraParams);

                startActivity(intent);
            }
        });

    }
}

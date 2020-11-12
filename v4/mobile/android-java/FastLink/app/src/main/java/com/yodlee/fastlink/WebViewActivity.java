// Copyright (c) 2019 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

package com.yodlee.fastlink;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;

public class WebViewActivity extends AppCompatActivity {

    public WebView webview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Reading the Data from Intent which is passed from LoginActivity
        Intent intent = getIntent();
        String fastlinkURL = intent.getStringExtra("fastlinkURL");
        String accessToken = intent.getStringExtra("accessToken");
        String extraParams = intent.getStringExtra("extraParams");

        setContentView(R.layout.activity_web_view);

        //Loading the WebView from the resource layout file
        webview = (WebView) findViewById(R.id.webview);
        webview.setWebViewClient(webClient);

        //Enable the following setting to debug the WebView in the Chrome browser
        //To debug the WebView, navigate to the chrome and type the 'chrome://inspect' url in the browser.
        WebView.setWebContentsDebuggingEnabled(true);

        webview.getSettings().setJavaScriptEnabled(true);
        webview.addJavascriptInterface(new JSInterfaceHandler(this), "YWebViewHandler");

        try {
            //Create the PostData in the String format
           String postData = "accessToken=Bearer " +  accessToken +"&extraParams=" + URLEncoder.encode( extraParams, "UTF-8");

            //Post the Data to to FastLink Server through WebView portUrl method.
            //This will load the FastLink application inside the WebView
            webview.postUrl(fastlinkURL, postData.getBytes());

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

    }

    WebViewClient webClient = new WebViewClient() {
        //To ByPass the SSL certificate error you can enable the following code.
        //This should not be enabled in the production. Production will have the valid certificate.
        @Override
        public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
            Boolean bypassSSLError = true;
            if (bypassSSLError) {
                // Ignore SSL certificate errors
                handler.proceed();
            }
        }
    };
}

class JSInterfaceHandler {
    Context mContext;
    ArrayList<String> eventsInfo = new ArrayList<String>();

    JSInterfaceHandler(Context c) {
        mContext = c;
    }

    @JavascriptInterface
    public void postMessage(final String data) {
        Log.d("FL:MESSAGE", data);
        eventsInfo.add(data);
        try {
            JSONObject userData = new JSONObject(data);
            String  type = userData.getString("type");
            JSONObject _data = userData.getJSONObject("data");

            if(type.equals("POST_MESSAGE")){
                if(_data.has("action") && _data.getString("action").equals("exit")){
                    Intent intent = new Intent(mContext.getApplicationContext(), EventsInfoActivity.class);
                    intent.putExtra("eventsInfo", eventsInfo);
                    mContext.startActivity(intent);
                }
            }

            if(type.equals("OPEN_EXTERNAL_URL")){
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(_data.getString("url")));
                mContext.startActivity(intent);
            }
        } catch (JSONException e){
            Log.d("FL:ERROR", e.getMessage());
        }
    }
}

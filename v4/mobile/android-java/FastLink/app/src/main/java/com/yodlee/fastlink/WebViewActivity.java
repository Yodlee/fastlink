// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

package com.yodlee.fastlink;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;


import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.yodlee.fastlink.util.DownloadFile;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;

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
            String postData = "accessToken=Bearer " + accessToken + "&extraParams=" + URLEncoder.encode(extraParams, "UTF-8");

            //Post the Data to to FastLink Server through WebView portUrl method.
            //This will load the FastLink application inside the WebView
            webview.postUrl(fastlinkURL, postData.getBytes());

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        isStoragePermissionGranted();
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

    public boolean isStoragePermissionGranted() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                return true;
            } else {

                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
                return false;
            }
        } else {
            return true;
        }
    }
}

class JSInterfaceHandler {
    Context mContext;
    ArrayList<String> eventsInfo = new ArrayList<String>();
    public static final String MIME_TYPE_PDF = "application/pdf";

    JSInterfaceHandler(Context c) {
        mContext = c;
    }

    @JavascriptInterface
    public void postMessage(final String data) {
        Log.d("FL:MESSAGE", data);
        eventsInfo.add(data);
        try {
            JSONObject userData = new JSONObject(data);
            String type = userData.getString("type");
            JSONObject _data = userData.getJSONObject("data");

            if (type.equals("POST_MESSAGE")) {
                if (_data.has("action") && _data.getString("action").equals("exit")) {
                    Intent intent = new Intent(mContext.getApplicationContext(), EventsInfoActivity.class);
                    intent.putExtra("eventsInfo", eventsInfo);
                    mContext.startActivity(intent);
                }
            }

            if (type.equals("OPEN_EXTERNAL_URL")) {

                String URL = _data.getString("url");
                String fileName = URL.substring(URL.lastIndexOf('/') + 1);
                String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
                if (extension.equalsIgnoreCase("pdf") && !canDisplayPdf(mContext)) {
                    new DownloadFile().execute(URL, fileName);
                } else {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(URL));
                    mContext.startActivity(intent);
                }
            }
        } catch (JSONException e) {
            Log.d("FL:ERROR", e.getMessage());
        }
    }

    public static boolean canDisplayPdf(Context context) {
        PackageManager packageManager = context.getPackageManager();
        Intent testIntent = new Intent(Intent.ACTION_VIEW);
        testIntent.setType(MIME_TYPE_PDF);
        if (packageManager.queryIntentActivities(testIntent, PackageManager.MATCH_DEFAULT_ONLY).size() > 0) {
            return true;
        } else {
            return false;
        }
    }
}

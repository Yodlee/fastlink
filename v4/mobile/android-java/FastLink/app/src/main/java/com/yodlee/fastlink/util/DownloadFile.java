// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

package com.yodlee.fastlink.util;

import java.io.File;
import java.io.IOException;

import android.os.AsyncTask;
import android.os.Environment;


public class DownloadFile extends AsyncTask<String, Void, Void> {

    @Override
    protected Void doInBackground(String... strings) {
        String fileUrl = strings[0];   // -> http://maven.apache.org/maven-1.x/maven.pdf
        String fileName = strings[1];  // -> maven.pdf
        String extStorageDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString();
        File folder = new File(extStorageDirectory);

        File pdfFile = new File(folder, fileName);

        try {
            pdfFile.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        FileDownloader.downloadFile(fileUrl, pdfFile);
        return null;
    }
}
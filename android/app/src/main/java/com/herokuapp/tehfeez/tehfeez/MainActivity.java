package com.herokuapp.tehfeez.tehfeez;

import io.flutter.embedding.android.FlutterActivity;

import android.app.PictureInPictureParams;
import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.util.Rational;
import android.view.Display;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import androidx.multidex.MultiDex;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.rortega.com.channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // if (call.method.equals("showNativeView")){
                                Display d = getWindowManager()
                                        .getDefaultDisplay();
                                Point p = new Point();
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
                                    d.getSize(p);
                                }
                                int width = p.x;
                                int height = p.y;
                                Rational ratio
                                        = null;
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                    ratio = new Rational(width, height);
                                }
                                PictureInPictureParams.Builder
                                        pip_Builder
                                        = null;
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    pip_Builder = new PictureInPictureParams.Builder();
                                }
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    pip_Builder.setAspectRatio(ratio).build();
                                }
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    enterPictureInPictureMode(pip_Builder.build());
                                }
                            // } else {
                            //     result.notImplemented();
                            // }
                        }
                );
    }
 
}

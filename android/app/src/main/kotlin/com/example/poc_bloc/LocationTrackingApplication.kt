package com.example.poc_bloc

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel


class LocationTrackingApplication : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            var name = "Location POC"
            var descriptionText = "Location Tracker"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val mChannel = NotificationChannel("0", name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }
      // createMethodChannel(applicationContext)
    }
}

fun  createMethodChannel(applicationContext: Context): MethodChannel? {

    var backgroundMethodChannel: MethodChannel? = null;
    var engine: FlutterEngine? = null;
    if (getEngine() == null) {
        engine = FlutterEngine(applicationContext!!)
        // Define a DartEntrypoint
        val entrypoint: DartExecutor.DartEntrypoint =
            DartExecutor.DartEntrypoint.createDefault()
        // Execute the DartEntrypoint within the FlutterEngine.
        engine.dartExecutor.executeDartEntrypoint(entrypoint)
    } else {
        engine = getEngine();
    }

    backgroundMethodChannel = engine?.dartExecutor?.binaryMessenger?.let {
        MethodChannel(
            it,
            "poc_bloc"
        )
    }
    return backgroundMethodChannel
}
fun getEngine(): FlutterEngine? {
    return FlutterEngineCache.getInstance().get("poc_bloc");
}
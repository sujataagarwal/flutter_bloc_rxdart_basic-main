package com.example.poc_bloc

import android.Manifest
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.annotation.NonNull
import com.example.poc_bloc.tracking.model.PathLocation
import com.example.poc_bloc.tracking.model.toJson
import com.example.poc_bloc.tracking.service.LocationTrackingService
import com.example.poc_bloc.tracking.service.TrackingListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), TrackingListener {
    private var serviceBoundResult: MethodChannel.Result? = null
    private var trackingService: LocationTrackingService? = null
    private var serviceBound = false
    private lateinit var connection: ServiceConnection

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.e("configureFlutterEngine", "configuring")

        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        flutterEngine?.dartExecutor?.let {
            MethodChannel(
                it.binaryMessenger,
                "poc_bloc"
            ).setMethodCallHandler { methodCall, result ->
                run {
                    when {
                        methodCall.method.equals("startTrackingService") -> {
                            startTrackingService()
                            result.success("Yes!! Tracking Successfully ")
                        }
                        methodCall.method.equals("startService") -> {
                            result.success(true)
                            serviceBoundResult = result
                            return@setMethodCallHandler
                        }
                        methodCall.method.equals("sendToBackground") -> {
                             var result =moveTaskToBack(true)
                            Log.e("task moved result ", result.toString())
                            //result.success("Yes!! Tracking Successfully ")
                        }

                    }
                }
            }!!
        }
    }

    override fun onStart() {
        super.onStart()
        bindService(object : LocationTrackingServiceHandler {
            override fun onBound() {
                Log.e("POC_BLOC", "Bound Service")
                trackingService?.attachListener(this@MainActivity)
                serviceBound = true
                serviceBoundResult?.let {
                    it.success(true)
                    serviceBoundResult = null
                }
            }
        })
    }

    override fun onStop() {
        super.onStop()
        trackingService?.let {
            it.attachListener(null)
            unbindService(connection)
            serviceBound = false
        }
    }


    private fun bindService(serviceHandler: LocationTrackingServiceHandler) {
        connection = object : ServiceConnection {
            override fun onServiceDisconnected(name: ComponentName?) {
                print("Binding Discounted")
                trackingService = null
            }

            override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                val binder = service as LocationTrackingService.LocalBinder
                trackingService = binder.getService()
                serviceHandler.onBound()
            }

        }
        val intent = Intent(this, LocationTrackingService::class.java)
        val result = startService(intent)
        Log.e("Started intent result", result.toString())
        bindService(intent, connection, Context.BIND_AUTO_CREATE)
    }



    interface LocationTrackingServiceHandler {
        fun onBound()
    }

    private fun startTrackingService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if ((checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                        != PackageManager.PERMISSION_GRANTED) && checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(
                    arrayOf(
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    ),
                    143
                )
                return
            } else {
               // startService(Intent(this, LocationTrackingService::class.java))
                //trackingService?.start()
            }
        }
    }
    override fun onNewLocation(location: PathLocation) {
        Log.e("POC_BLOC1", "onNewLocation")
        location.toJson()?.let {
            invokePathLocation(it)
        }    }

    private fun invokePathLocation(pathLocation: String) {
        Log.e("invoke Path", pathLocation)
        flutterEngine?.dartExecutor?.let {
            MethodChannel(
                it.binaryMessenger,
                "poc_bloc"
            ).invokeMethod("locationTrackingService", pathLocation)
        }
    }


}

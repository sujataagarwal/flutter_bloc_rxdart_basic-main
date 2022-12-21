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
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), TrackingListener {
    private var serviceBoundResult: MethodChannel.Result? = null
    private var trackingService: LocationTrackingService? = null
    private var serviceBound = false
    private lateinit var connection: ServiceConnection

    object StaticChannel{
        var methodChannel : MethodChannel ?= null
        var flutterEngine: FlutterEngine ?= null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        StaticChannel.flutterEngine = getFlutterEngine()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        StaticChannel.methodChannel = flutterEngine?.dartExecutor?.let{
            MethodChannel(it.binaryMessenger, "poc_bloc")
        }
        StaticChannel.methodChannel?.setMethodCallHandler { methodCall, result ->
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
                }
            }
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

    override fun onNewLocation(location: PathLocation) {
        location.toJson()?.let {
            invokePathLocation(it)
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
        bindService(intent, connection, Context.BIND_AUTO_CREATE)
    }

    private fun startTrackingService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if ((checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                        != PackageManager.PERMISSION_GRANTED) && checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION),
                    143)
                return
            } else {
                startService(Intent(this, LocationTrackingService::class.java))
            }        }
    }

    private fun invokePathLocation(pathLocation: String) {
        StaticChannel.methodChannel?.invokeMethod("locationTrackingService", pathLocation)
       }

    interface LocationTrackingServiceHandler {
        fun onBound()
    }
}

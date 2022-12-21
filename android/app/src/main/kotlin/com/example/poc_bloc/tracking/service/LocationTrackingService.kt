package com.example.poc_bloc.tracking.service

import android.Manifest
import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Criteria
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Binder
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import com.example.poc_bloc.R
import com.example.poc_bloc.tracking.model.PathLocation
import com.example.poc_bloc.tracking.model.toJson
import com.example.poc_bloc.utils.VersionChecker

private const val GPS_TRACKING_IN_MILLIS: Long = 0
private const val GPS_TRACKING_IN_DISTANCE_METERS: Float = 1f

class LocationTrackingService : Service(), LocationListener {
    private var listener: TrackingListener? = null
    private var isTracking: Boolean = false
    private lateinit var locationManager: LocationManager


    override fun onCreate() {
        super.onCreate()
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        createNotificationChannel()
        startForegroundNotification()
        initLocationTracking()
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder = LocalBinder()

    fun attachListener(listener: TrackingListener?) {
        this.listener = listener
    }

    override fun onLocationChanged(location: Location) {
            listener?.onNewLocation(PathLocation.fromLocation(location))
           updateNotification(PathLocation.fromLocation(location))
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onProviderEnabled(provider: String) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onProviderDisabled(provider: String) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "poc_bloc",
                "poc_bloc_foreground",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager: NotificationManager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun startForegroundNotification() {
        if (VersionChecker.isGreaterThanOrEqualToOreo()) {
            val builder: Notification.Builder =
                Notification.Builder(this, "poc_bloc")
                    .setContentText("Tracking mode")
                    .setContentTitle("Background service")
                    .setSmallIcon(R.drawable.launch_background)
            startForeground(143, builder.build())
        }
    }

    private fun getLocationCriteria(): Criteria {
        val criteria = Criteria()
        criteria.accuracy = Criteria.ACCURACY_FINE
        criteria.powerRequirement = Criteria.POWER_HIGH
        criteria.isAltitudeRequired = false
        criteria.isSpeedRequired = false
        criteria.isCostAllowed = true
        criteria.isBearingRequired = false
        criteria.horizontalAccuracy = Criteria.ACCURACY_HIGH
        criteria.verticalAccuracy = Criteria.ACCURACY_HIGH
        return criteria
    }

    private fun initLocationTracking() {
        if (VersionChecker.isGreaterThanOrEqualToOreo()) {

            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) return
            isTracking = true
            locationManager.requestLocationUpdates(
                GPS_TRACKING_IN_MILLIS,
                GPS_TRACKING_IN_DISTANCE_METERS,
                getLocationCriteria(),
                this,
                null
            )
        }
    }

    private fun updateNotification(location: PathLocation) {
        if (VersionChecker.isGreaterThanOrEqualToOreo()) {
            var notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            var message = "" + location.toJson()
            val builder: Notification.Builder =
                Notification.Builder(this, "poc_bloc")
                    .setContentText(message)
                    .setContentTitle("Current Location")
                    .setSmallIcon(R.drawable.launch_background)
            notificationManager.notify(0, builder.build())
        }
    }


    inner class LocalBinder : Binder() {
        fun getService(): LocationTrackingService = this@LocationTrackingService
    }


}
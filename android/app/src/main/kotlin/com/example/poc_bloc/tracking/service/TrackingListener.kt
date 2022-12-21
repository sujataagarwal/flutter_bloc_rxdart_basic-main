package com.example.poc_bloc.tracking.service

import com.example.poc_bloc.tracking.model.PathLocation

interface TrackingListener {
    fun onNewLocation(location: PathLocation)
}
package com.example.poc_bloc.tracking.model

import android.location.Location
import com.google.gson.Gson

data class PathLocation(
        private val latitude: Double,
        private val longitude: Double
) {
    companion object {
        fun fromLocation(location: Location) =
                PathLocation(location.latitude, location.longitude)
    }

}

fun PathLocation.toJson(): String? = Gson().toJson(this)
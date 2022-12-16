package com.example.poc_bloc.utils

import android.os.Build

object VersionChecker {
    fun isGreaterThanOrEqualToOreo() =
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
}
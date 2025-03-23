package com.abdul.safekids

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Process
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app_blocking"

    @RequiresApi(Build.VERSION_CODES.CUPCAKE)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAppRunning" -> {
                    val packageName = call.argument<String>("package")
                    result.success(isAppRunning(packageName ?: ""))
                }
                "closeApp" -> {
                    val packageName = call.argument<String>("package")
                    closeApp(packageName ?: "")
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.CUPCAKE)
    private fun isAppRunning(packageName: String): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningProcesses = activityManager.runningAppProcesses
        for (process in runningProcesses) {
            if (process.processName == packageName) {
                return true
            }
        }
        return false
    }

    @RequiresApi(Build.VERSION_CODES.CUPCAKE)
    private fun closeApp(packageName: String) {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningProcesses = activityManager.runningAppProcesses
        for (process in runningProcesses) {
            if (process.processName == packageName) {
                Process.killProcess(process.pid)
            }
        }
    }
}


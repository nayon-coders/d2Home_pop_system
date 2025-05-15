package com.posd2home.tableapp

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.UUID

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.printer/classic"
    private val SPP_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "printToClassic") {
                val address = call.argument<String>("address")
                val dataList = call.argument<List<Int>>("data")
                if (address != null && dataList != null) {
                    val data = dataList.map { it.toByte() }.toByteArray()
                    val printResult = printToClassicDevice(address, data)
                    result.success(printResult)
                } else {
                    result.error("INVALID_ARGS", "Address or data missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun printToClassicDevice(address: String, data: ByteArray): String {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter == null) {
            return "Bluetooth not supported on this device"
        }
        if (!bluetoothAdapter.isEnabled) {
            return "Bluetooth is not enabled"
        }

        val device: BluetoothDevice = bluetoothAdapter.getRemoteDevice(address)
        var socket: BluetoothSocket? = null
        try {
            socket = device.createRfcommSocketToServiceRecord(SPP_UUID)
            socket.connect() // আপনি যদি থ্রেড ব্লকিং এড়াতে চান, তবে এখানে ব্যাকগ্রাউন্ড থ্রেড ব্যবহার করুন
            val outputStream = socket.outputStream
            outputStream.write(data)
            outputStream.flush()
            return "Print command sent to ${device.name}"
        } catch (e: IOException) {
            return "Failed to print: ${e.message}"
        } finally {
            try {
                socket?.close() // socket বন্ধ করা নিশ্চিত করুন
            } catch (e: IOException) {
                // Ignore close errors
            }
        }
    }

}
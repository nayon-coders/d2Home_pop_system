// printer_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:admin_desktop/src/presentation/pages/printer_manage/model/single_order_details_printer_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/local_storage.dart';
import '../../../../models/response/sale_history_response.dart';

class PrinterController extends GetxController {
  static PrinterController get to => Get.find();

  static const platform = MethodChannel('com.example.printer/classic');


  final RxBool isScanning = false.obs;
  final RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;
  final Rx<BluetoothDevice?> selectedDevice = Rx<BluetoothDevice?>(null);
  final RxBool isConnected = false.obs;
  final RxString printerName = ''.obs;
  final RxString printerAddress = ''.obs;
  final Set<String> bleDeviceIds = <String>{};

  RxInt clipes = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getSavedPrinter();
    _fetchBondedDevices();
    //checkSavedPrinter();
  }

  getSavedPrinter()async{
    final prefs = await SharedPreferences.getInstance();
    final priterName = prefs.getString('printer_name');
    final savedAddress = prefs.getString('printer_id');
    printerName.value = priterName!;
    printerAddress.value = savedAddress!;
  }

  Future<void> checkSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final priterName = prefs.getString('printer_name');
    final savedAddress = prefs.getString('printer_id');

    if (priterName != null && savedAddress != null && devices.isNotEmpty) {
      printerName.value = priterName;
      printerAddress.value = savedAddress;
      await attemptAutoReconnect(savedAddress, priterName);
    } else {
      // Show initial connection dialog if no saved printer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showInitialConnectionDialog(Get.context!);
      });
    }

    print("printerName --- ${printerName.value}");
  }
  Future<void> attemptAutoReconnect(printerAddressId, printerName) async {
    try {
      final device = devices.firstWhere(
            (d) => d.id.toString() == printerAddressId,
        orElse: () => throw Exception('Printer not in list'),
      );

      await connectToPrinter(device, Get.context!);
    } catch (e) {
      Get.snackbar('Reconnection Failed', 'Could not reconnect to saved printer',
          backgroundColor: Colors.orange);
      await disconnectPrinter();
      print("printerAddress.value --- ${printerAddress.value} $e");
    }
  }




  Future<void> startPrinterScan(BuildContext context) async {
    try {
      isScanning.value = true;
      devices.clear();
      bleDeviceIds.clear();

      if (!await FlutterBluePlus.isOn) {
        throw Exception('Bluetooth is not enabled');
      }

      await _fetchBondedDevices();
      await _scanBleDevices();

      if (devices.isEmpty) {
        throw Exception('No printers found');
      }

    } catch (e) {

      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print("error: $e");

    } finally {
      isScanning.value = false;
    }
  }

  Future<void> _fetchBondedDevices() async {
    try {
      final bondedDevices = await FlutterBluePlus.bondedDevices;
      devices.addAll(bondedDevices.where((d) => d.name.isNotEmpty));
    } catch (e) {
      print('Error fetching bonded devices: $e');
    }
  }

  RxBool isScanningPrinter = false.obs;
  Future<void> _scanBleDevices() async {
    try {
      isScanningPrinter.value = true;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          if (result.device.name.isNotEmpty &&
              !devices.contains(result.device)) {
            devices.add(result.device);
            bleDeviceIds.add(result.device.id.toString());
          }
        }
      });

      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();
    } catch (e) {
      isScanningPrinter.value = false;
      print('BLE scan error: $e');
    }
  }



  Future<void> connectToPrinter(BluetoothDevice device, BuildContext context) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Important: Request permissions first
      await _requestBluetoothPermissions();

      // Cancel previous connection
      if (isConnected.value) {
        await disconnectPrinter();
        await Future.delayed(const Duration(seconds: 1));
      }

      // Connection parameters
      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) {
        print('Service UUID: ${service.uuid}');
      });

      // Store connection
      _storePrinterConnection(device);

      // Update state
      isConnected.value = true;
      selectedDevice.value = device;

      Get.back(); // Close dialog
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Connected to ${device.name}',
          backgroundColor: Colors.green, colorText: Colors.white);
      isScanning.value = false;
      isScanningPrinter.value = false;
    } catch (e) {
      Get.back();
      Get.snackbar('Connection Failed', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Connection Error Details: $e');
      await disconnectPrinter();
    }
  }

  Future<void> _requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothScan.request();
      await Permission.locationWhenInUse.request();
    }
  }

  void _storePrinterConnection(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_id', device.id.toString());
    await prefs.setString('printer_name', device.name);

    getSavedPrinter();
  }




  Future<void> disconnectPrinter() async {
    if (selectedDevice.value != null) {
      await selectedDevice.value!.disconnect();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('printer_name');
    await prefs.remove('printer_address');

    isConnected.value = false;
    selectedDevice.value = null;
    printerName.value = '';
    printerAddress.value = '';
  }








  //show popup
  Future<void> showInitialConnectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade100,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.print_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Connect Your Printer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Content
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'To get started, connect your Bluetooth printer. '
                      'You only need to do this once!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Later Button
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.blue.shade800),
                    ),
                    child: const Text(
                      'Maybe Later',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Connect Button
                  MaterialButton(
                    onPressed: () {
                     // Navigator.pop(context);
                      startPrinterScan(context);
                    },
                    color: Colors.blue.shade800,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:    Obx(() {
                        return isScanningPrinter.value ? Center(child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,),) : Text(
                          'Connect Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }


  RxBool isPrinting = false.obs;

  Future<void> printReceipt(
      BuildContext context, int copies, id) async {
    print("Starting print process...");


    // if (selectedDevice.value == null) {
    //   Get.snackbar("Error", "No printer selected",
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.red,
    //       colorText: Colors.white);
    //   return;
    // }
    //getting data -----
    var response = await getSingleOrderDetailsModel(id);
    if(response.statusCode == 200){
      print("order getting success...");
      //model
      SingleOrderDetailsPrinterModel data = SingleOrderDetailsPrinterModel.fromJson(jsonDecode(response.body));
      isPrinting.value = true;

      try {
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm80, profile);

        const PosStyles defaultStyle = PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        );

        bool isBle = bleDeviceIds.contains(selectedDevice.value!.id.toString());

        for (int copy = 1; copy <= copies; copy++) {
          print("Printing copy $copy of $copies");

          List<List<int>> chunks = [];
          List<int> currentChunk = [];

          void addToChunk(List<int> bytes, {bool forceNewChunk = false}) {
            int maxChunkSize = isBle ? 256 : 1024;

            if (forceNewChunk || currentChunk.length + bytes.length > maxChunkSize) {
              if (currentChunk.isNotEmpty) chunks.add(currentChunk);
              currentChunk = [];
            }
            currentChunk.addAll(bytes);
          }

          // Header
          addToChunk(generator.reset(), forceNewChunk: true);
          await Future.delayed(Duration(milliseconds: 100));
          addToChunk(generator.setGlobalCodeTable('CP1252'));

          addToChunk(generator.text('D2Home POS - Copy $copy',
              styles: PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size4,
                width: PosTextSize.size4,
                bold: true,
              )));
          addToChunk(generator.feed(1));

          // Divider
          addToChunk(generator.text('--------------------------------',
              styles: defaultStyle.copyWith(align: PosAlign.center, bold: true)));

          // Example Body (you can insert dynamic order data here)
          addToChunk(generator.text('Order ID: ${data.data!.id}',
              styles: defaultStyle.copyWith(align: PosAlign.left)));
          addToChunk(generator.text('Date: ${data.data!.createdAt}',
              styles: defaultStyle.copyWith(align: PosAlign.left)));

          // Footer
          addToChunk(generator.feed(1));
          addToChunk(generator.text('Thanks for choosing us.',
              styles: defaultStyle.copyWith(align: PosAlign.center)));
          addToChunk(generator.feed(2));
          addToChunk(generator.text('********************************',
              styles: defaultStyle.copyWith(align: PosAlign.center, bold: true)));
          addToChunk(generator.feed(3));

          if (currentChunk.isNotEmpty) {
            chunks.add(currentChunk);
          }

          // Send chunks to printer
          for (var chunk in chunks) {
            try {
              if (isBle) {
                await printViaBle(selectedDevice.value!, chunk);
                await Future.delayed(Duration(milliseconds: 200));
              } else {
                await printViaClassic(selectedDevice.value!, chunk);
                await Future.delayed(Duration(milliseconds: 50));
              }
            } catch (e) {
              print("Error printing chunk: $e");
              await Future.delayed(Duration(milliseconds: 300));
              // Try again once
              try {
                if (isBle) {
                  await printViaBle(selectedDevice.value!, chunk);
                } else {
                  await printViaClassic(selectedDevice.value!, chunk);
                }
              } catch (e) {
                print("Retry failed: $e");
              }
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Print completed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Get.back();
      } catch (e) {
        print("Print Error: $e");
        Get.snackbar("Error!", "Print failed: (Order full data not retrieved)",
            backgroundColor: Colors.red);
        Get.back();
      } finally {
        isPrinting.value = false;
      }
    }else{
      //order details nto getting...
      print("order not getting..");
      return;
    }



  }


  Future<void> printViaBle(BluetoothDevice device, List<int> bytes) async {
    await device.connect(timeout: const Duration(seconds: 10));
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write ||
            characteristic.properties.writeWithoutResponse) {
          await characteristic.write(bytes,
              withoutResponse: characteristic.properties.writeWithoutResponse);
          break;
        }
      }
      break;
    }
    await Future.delayed(const Duration(seconds: 2));
    await device.disconnect();
  }

  Future<void> printViaClassic(BluetoothDevice device, List<int> bytes) async {
    final String result = await platform.invokeMethod('printToClassic', {
      'address': device.id.toString(),
      'data': bytes,
    });
    print("Classic print result: $result");
  }




  String _formatLine(String left, String right, int lineLength) {
    int maxLeftLength = lineLength - right.length;
    if (left.length > maxLeftLength) {
      left = '${left.substring(0, maxLeftLength - 1)}.';
    }
    return left.padRight(lineLength - right.length) + right;
  }

  String _formatLineWithoutQuantity(String left, String right, int lineLength) {
    return _formatLine(left, right, lineLength);
  }


  String formatLine(String quantity, String name, String price, int lineWidth) {
    String leftText = '$quantity X $name';
    int leftTextLength = leftText.length;
    int priceLength = price.length;
    int spaces = lineWidth - (leftTextLength + priceLength);
    spaces = spaces > 0 ? spaces : 0;
    return '$leftText${' ' * spaces}$price';
  }

  String formatLineWithoutQuantity(String name, String price, int lineWidth) {
    int nameLength = name.length;
    int priceLength = price.length;
    int spaces = lineWidth - (nameLength + priceLength);
    spaces = spaces > 0 ? spaces : 0;
    return '$name${' ' * spaces}$price';
  }
  
  
  
  //get single order details
  RxBool isGettingData = false.obs; 
  Future<http.Response> getSingleOrderDetailsModel(id)async{
    isGettingData.value = true; 
    var response = await http.get(Uri.parse("https://api.d2home.com.au/api/v1/dashboard/${LocalStorage.getUser()?.role}/orders/${id}?lang=en"),
      headers: {
        "Authorization" : "Bearer ${LocalStorage.getToken()}"
      }
    );
    print("single data --- ${response.body}");
    isGettingData.value = false;
    return response;
  }

}
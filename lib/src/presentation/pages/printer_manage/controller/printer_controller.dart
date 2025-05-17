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
  final List<String> bleDeviceIds = <String>[];

  RxInt clipes = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getSavedPrinter();
    _fetchBondedDevices();
    checkSavedPrinter();
    //checkSavedPrinter();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.locationWhenInUse]!.isGranted) {
      print('Permissions granted successfully');
    } else {
      print('Permissions denied: $statuses');
      Get.snackbar("Permission Error", "Please grant all permissions",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  getSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final priterName = prefs.getString('printer_name');
    final savedAddress = prefs.getString('printer_id');
    printerName.value = priterName ?? "";
    printerAddress.value = savedAddress ?? "";
  }

  Future<void> checkSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final priterName = prefs.getString('printer_name');
    final savedAddress = prefs.getString('printer_id');

    if (priterName != null && savedAddress != null && devices.isNotEmpty) {
      printerName.value = priterName;
      printerAddress.value = savedAddress;
      await attemptAutoReconnect(savedAddress, priterName);
    } else {}

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
      Get.snackbar(
          'Reconnection Failed', 'Could not reconnect to saved printer',
          backgroundColor: Colors.orange);
      await disconnectPrinter();
      print("printerAddress.value --- ${printerAddress.value} $e");
    }
  }

  Future<void> startPrinterScan(BuildContext context) async {
    try {
      isScanning.value = true;

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
    bleDeviceIds.clear();
    try {
      isScanningPrinter.value = true;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          devices.add(result.device);
          // Debugging: Check device id
          print('Scanned device ID: ${result.device.id}');
          bleDeviceIds.add(result.device.id.toString());
        }
      });

      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();
    } catch (e) {
      isScanningPrinter.value = false;
      print('BLE scan error: $e');
    }

    print('BLEdevice id:  ${bleDeviceIds}');
  }

  Future<void> connectToPrinter(
      BluetoothDevice device, BuildContext context) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Important: Request permissions first
      //   await _requestBluetoothPermissions();

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

  RxBool isPrinting = false.obs;

  Future<void> printReceipt(
      BuildContext context, SaleHistoryModel data, int copies) async {
    print("Starting print process...");
    if (selectedDevice.value == null) {
      Get.snackbar("Error", "No printer selected",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    const PosStyles bigFont = PosStyles(
        fontType: PosFontType.fontA,
        align: PosAlign.center,
        height: PosTextSize.size2, // Changed from size2 to size4
        width: PosTextSize.size2, // Changed from size2 to size4
        bold: true
    );

     PosStyles mediumFont({PosAlign align = PosAlign.center, PosTextSize height = PosTextSize.size2,  PosTextSize weight = PosTextSize.size2, }) => PosStyles(
        fontType: PosFontType.fontB,
        align: align,
        height: height, // Changed from size2 to size4
        width: weight, // Changed from size2 to size4
        bold: true
    );

    const PosStyles customerInfoStyle = PosStyles(
      height: PosTextSize.size1,
      width: PosTextSize.size1,
      align: PosAlign.center, // All text centered
    );

    isPrinting.value = true;

    //getting single data
    SingleOrderDetailsPrinterModel orderModel =
    SingleOrderDetailsPrinterModel();
    var response = await getSingleOrderDetailsModel(data.id.toString());
    if (response.statusCode == 200) {
      orderModel =
          SingleOrderDetailsPrinterModel.fromJson(jsonDecode(response.body));
    }

    try {
      for (var i = 0; i < copies; i++) {
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm80, profile);

        // Split into chunks to prevent buffer overflow
        List<List<int>> chunks = [];
        List<int> currentChunk = [];
        bool isBle = bleDeviceIds.contains(selectedDevice.value!.id.toString());

        void addToChunk(List<int> bytes, {bool forceNewChunk = false}) {
          // For BLE, we need smaller chunks (512 bytes)
          // For classic Bluetooth, we can use larger chunks (2048 bytes)
          int maxChunkSize = isBle ? 512 : 2048;

          if (forceNewChunk ||
              currentChunk.length + bytes.length > maxChunkSize) {
            if (currentChunk.isNotEmpty) chunks.add(currentChunk);
            currentChunk = [];
          }
          currentChunk.addAll(bytes);
        }

        // 1. Printer initialization
        addToChunk(generator.reset(), forceNewChunk: true);
        addToChunk(
            generator.setGlobalCodeTable('CP1252')); // Ensure proper encoding

        addToChunk(generator.text("${orderModel.data!.shop!.translation!.title}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size3, // Changed from size2 to size4
              width: PosTextSize.size3, // Changed from size2 to size4
              bold: true,
            )));
        addToChunk(generator.feed(1));

        addToChunk(generator.text("Order ID: ${orderModel.data!.id!}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size2, // Changed from size2 to size4
              width: PosTextSize.size2, // Changed from size2 to size4
              bold: true,
            )));
        addToChunk(generator.feed(1));



        addToChunk(generator.text(orderModel.data?.address?.address ?? '',
            styles: customerInfoStyle)); // Centered address

        addToChunk(generator.text(orderModel.data?.user?.phone ?? '-',
            styles: customerInfoStyle)); // Centered phone

        addToChunk(generator.text('Order Time: ${orderModel.data?.createdAt}',
            styles: customerInfoStyle)); // Centered time

        addToChunk(generator.text(
            'Customer Name: ${orderModel.data?.user?.firstname} ${orderModel.data?.user?.lastname}',
            styles: customerInfoStyle)); // Centered name

        addToChunk(generator.feed(1));

        addToChunk(generator.text("Order Items",
            styles: mediumFont()
        ));
        addToChunk(generator.feed(1));
        addToChunk(generator.text('-------------------------',
            styles:mediumFont()));

        int totalQuantity = orderModel.data!.details!
            .fold(0, (sum, item) => sum + (item.quantity ?? 0));

        addToChunk(generator.text('Order Items (Total: $totalQuantity)',
            styles: mediumFont(align: PosAlign.left)));
        addToChunk(generator.text('-----------------------',
            styles: mediumFont()));

        for (var item in orderModel.data!.details!) {
          String quantity = item.quantity?.toString() ?? "1";
          String price = item.stock?.totalPrice?.toString() ?? "0.00";
          double totalPrice =
              (double.tryParse(price) ?? 0) * (double.tryParse(quantity) ?? 1);
          String productName =
              item.stock?.product?.translation?.title ?? "Item";

          String left = '$quantity X $productName';
          String right = '\$${totalPrice.toStringAsFixed(2)}';
          String line = _formatLine(left, right, 32);

          addToChunk(
              generator.text(line,
                  styles: mediumFont()),
              forceNewChunk: false);

          // Addons (unchanged, but quantities not included in total)
          item.addons?.forEach((addon) {
            String addonQty = addon.quantity?.toString() ?? "1";
            String addonPrice = addon.stock?.totalPrice?.toString() ?? "0.00";
            String addonName =
                addon.stock?.product?.translation?.title ?? "Addon";

            String addonLeft = '+$addonQty X $addonName';
            String addonRight =
                '\$${double.parse(addonPrice).toStringAsFixed(2)}';
            String addonLine = _formatLine(addonLeft, addonRight, 32);

            addToChunk(
                generator.text(addonLine,
                    styles: mediumFont(align: PosAlign.left)),
                forceNewChunk: false);
          });

          if (item.stock?.extras?.isNotEmpty ?? false) {
            addToChunk(
                generator.text(
                    '(${item.stock!.extras!.map((e) => e.value ?? "").join(", ")})',
                    styles: mediumFont(align: PosAlign.left)),
                forceNewChunk: false);
          }
          addToChunk(generator.feed(1), forceNewChunk: true);
        }
        addToChunk(generator.text('--------------------------------',
            styles: mediumFont()));

        final summaryItems = [
          {
            "label": "Sub total",
            "value": orderModel.data!.originPrice!.toStringAsFixed(2)
          },
          {
            "label": "Delivery fee",
            "value": orderModel.data!.deliveryFee?.toStringAsFixed(2) ?? "0.00"
          },
          // {
          //   "label": "Commission fee",
          //   "value": orderModel.data!.commissionFee?.toStringAsFixed(2) ?? "0.00"
          // },
          // {
          //   "label": "Commission fee",
          //   "value": orderModel.data!.?.toStringAsFixed(2) ?? "0.00"
          // },
          // {
          //   "label": "Service fee",
          //   "value": orderModel.data!.serviceFee?.toStringAsFixed(2) ?? "0.00"
          // },
        ];

        for (var item in summaryItems) {
          // Manually format the line to match your image exactly
          String line = item["label"]!.padRight(20) + "\$${item["value"]}".padLeft(40);

          addToChunk(
              generator.text(line,
                  styles: PosStyles(
                    height: PosTextSize.size1,
                    width: PosTextSize.size1,
                  )),
              forceNewChunk: true);
        }

        // 9. Total section with font size 2
        addToChunk(generator.text('--------------------------------',
            styles: mediumFont()));

        addToChunk(
            generator.text(
                _formatLineWithoutQuantity(
                    "Total",
                    "\$${orderModel.data?.totalPrice?.toStringAsFixed(2) ?? "0.00"}",
                    32),
                styles: mediumFont()),
            forceNewChunk: true);

        // 10. Footer with CUT command and font size 2
        addToChunk(generator.text('--------------------------------',
            styles: mediumFont()));
        addToChunk(generator.feed(1));
        addToChunk(generator.text('Thanks for choosing us.',
            styles: mediumFont()));
        addToChunk(generator.feed(2));
        addToChunk(generator.text('********************************',
            styles:mediumFont()));
        addToChunk(generator.feed(3));

        // IMPORTANT: Add the cut command in its own chunk
        addToChunk(generator.cut(mode: PosCutMode.full), forceNewChunk: true);

        // Add any remaining bytes
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk);
        }

        print("isBle---- ${isBle}");

        // Print all chunks with appropriate delays
        // Print all chunks with appropriate delays
        for (var chunk in chunks) {
          try {
            if (isBle) {
              await printViaBle(selectedDevice.value!, chunk);
              await Future.delayed(
                  Duration(milliseconds: chunk.length > 256 ? 200 : 100));
            } else {
              await printViaClassic(selectedDevice.value!, chunk);
              if (chunk.length > 1024) {
                await Future.delayed(Duration(milliseconds: 50));
              }
            }
          } catch (e) {
            print("Error printing chunk: $e");
            await Future.delayed(Duration(milliseconds: 300));
            // Try one more time
            if (isBle) {
              await printViaBle(selectedDevice.value!, chunk);
            } else {
              await printViaClassic(selectedDevice.value!, chunk);
            }
          }
        }
       Get.snackbar("Success!", "Recipe print Success!", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Print Error: $e");
      Get.snackbar("Failed!", "Recipe printer failed!", backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPrinting.value = false;
    }
  }

  Future<void> printViaBle(BluetoothDevice device, List<int> bytes) async {
    try {
      // if (device.isConnected) {
      //   await device.disconnect(); // double safety
      // }

      await device.connect(timeout: const Duration(seconds: 10));
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write ||
              characteristic.properties.writeWithoutResponse) {
            await characteristic.write(bytes,
                withoutResponse:
                characteristic.properties.writeWithoutResponse);
            break;
          }
        }
      }

      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      print('Print Error: $e');
    } finally {
      // if (device.isConnected) {
      //   await device.disconnect();
      // }
    }
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
  Future<http.Response> getSingleOrderDetailsModel(id) async {
    isGettingData.value = true;
    var response = await http.get(
        Uri.parse(
            "https://api.d2home.com.au/api/v1/dashboard/${LocalStorage.getUser()?.role}/orders/${id}?lang=en"),
        headers: {"Authorization": "Bearer ${LocalStorage.getToken()}"});
    print("single data --- ${response.body}");
    isGettingData.value = false;
    return response;
  }
}

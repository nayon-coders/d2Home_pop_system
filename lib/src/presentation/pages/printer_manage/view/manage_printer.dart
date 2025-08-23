import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../../../components/custom_scaffold.dart';
import '../../../theme/app_style.dart';

class PrinterSetting extends GetView<PrinterController> {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.mainBack,

        extendBody: true,
        
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Printer Setup",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),

                  IconButton(
                    onPressed: ()=> controller.startPrinterScan(context) ,
                    icon: Obx(() {
                      return controller.isScanning.value ? Center(child: CircularProgressIndicator.adaptive(backgroundColor: AppStyle.blue,),) : Icon(Icons.refresh, color: AppStyle.blue, size: 20,);
                    }
                    ),
                  )
                ],
              ),

              Obx((){
                return controller.devices.isEmpty ? _scanPrinter(context) : Center();
              }),
              Obx((){
                  return controller.selectedDevice.value != null ?  _connectPrinter(controller.selectedDevice.value!)  :Center();
              }),
              _showPrinter(context)
            ],
          ),
        )
      ),
    );
  }

  _scanPrinter(context) {
  return  Center(
    child: Container(
        height: 200,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
              return controller.isScanning.value ? Center(child: CircularProgressIndicator.adaptive(backgroundColor: AppStyle.blue,),) : Icon(Icons.refresh, color: AppStyle.blue,);
            }
          ),
          Center(
            child: TextButton(
                onPressed: ()=>controller.startPrinterScan(context),
                child: controller.isScanning.value ? Text("Scanning....")  : Text("Scan printer")),
          ),
        ],
      ),
      ),
  );
  }

  _showPrinter(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(height: 5,),
        Text("Available Printer",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 5,),
        Obx((){
          return controller.isScanning.value ? _scanPrinter(context) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.devices!.value.map((data){
                return data ==   controller.selectedDevice.value ? Center() : ListTile(
                  title: Text(data.name.isNotEmpty ? data.name : "Unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  subtitle:  Text("${data.id}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  leading: Icon(Icons.print, size: 40,),
                  trailing: InkWell(
                    onTap: (){
                      showSimpleConfirmationPopup(
                        title: 'Connect to Printer?',
                        message: 'Are you sure you want to connect to this printer?',
                        onConfirm: () {
                          controller.connectToPrinter(data, context);
                        },
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(
                        child: Text("Connect",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        ),
      ],
    );
  }

  _connectPrinter(BluetoothDevice device){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Connected Printer",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 5,),
        ListTile(
          title: Text("${device.name}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          subtitle:  Text("${device.id}",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          leading: Icon(Icons.print, size: 40,),
          trailing: InkWell(
            onTap: (){
              showSimpleConfirmationPopup(
                title: 'Disconnect to Printer?',
                message: 'Are you sure you want to disconnect to this printer?',
                onConfirm: () {
                  controller.disconnectPrinter();
                },
              );
            },
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Center(
                child: Text("Disconnect",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5,),
        Divider(height: 1, color: Colors.grey,),
        SizedBox(height: 5,),
      ],
    );
  }



  void showSimpleConfirmationPopup({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue)
            ),
            onPressed: () {
              Get.back(); // close dialog
              onConfirm(); // run action
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }


}

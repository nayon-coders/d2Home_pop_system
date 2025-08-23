import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/response/sale_history_response.dart';

void showPrinterPopup(BuildContext context, SaleHistoryModel data) {
  
  int copies = 1;
  bool openDrawer = false;
  bool printFrontSeparate = false;
  bool printBackSeparate = false;
  String selectedType = '58 mm';

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "You're Printing Using D2home App",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Type print", style: TextStyle(fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedType,
                        items: ['58 mm', '80 mm']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => selectedType = val!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Copies", style: TextStyle(fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (copies > 1) setState(() => copies--);
                        },
                      ),
                      Text('$copies'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => copies++),
                      ),
                      const Spacer(),
                      const Text("Open Drawer",  style: TextStyle(fontWeight: FontWeight.w500),),
                      Switch(
                        value: openDrawer,
                        onChanged: (val) => setState(() => openDrawer = val),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Print Front Items Separate",  style: TextStyle(fontWeight: FontWeight.w500),),
                      Switch(
                        value: printFrontSeparate,
                        onChanged: (val) => setState(() => printFrontSeparate = val),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Print Back Items Separate",  style: TextStyle(fontWeight: FontWeight.w500),),
                      Switch(
                        value: printBackSeparate,
                        onChanged: (val) => setState(() => printBackSeparate = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // Handle printer search logic here
                          },
                          child: const Text("Close"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // Handle printer search logic here
                           // Get.find<PrinterController>().testPrint(context);
                            Get.find<PrinterController>().printReceipt(context, data, copies );
                          },
                          child: const Text("Print"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

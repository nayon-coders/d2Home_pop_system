import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Holds the currently selected payment method
final selectedPaymentProvider = StateProvider<String>((ref) => 'Cash');


class PaymentHelper {
  String getSelectedPayment(WidgetRef ref) {
    final selected = ref.read(selectedPaymentProvider);
    return selected;
  }
}




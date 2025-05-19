import 'package:get/get.dart';

class PaymentCalculatorController extends GetxController {
  RxString balanceAmount = "0.00".obs; // Refund or Remaining amount
  RxString balanceType = "Remaining".obs; // Label: "Refund" or "Remaining"
  // Input value from calculator
  var calculate = ''.obs;

  // Finalized values
  RxString cashAmountStr = "".obs;
  RxString cardAmountStr = "".obs;
  RxString refundAmount = "".obs;
  var inputAmount = "".obs;

  // Selected payment mode
  var selectedPayment = 'Cash'.obs;


  RxBool isSelectCashBox = true.obs;
  changeSelectionBox(value) {
    isSelectCashBox.value = value;
    updateCalculateFromBox(); // update box
  }


  //selected payment method
  RxString selectedPaymentOption = "Cash".obs;
  void selectedPaymentMethod(data) {
    balanceAmount.value = "";
    balanceType.value = "";
    updateCalculateFromBox(); // update box
       calculate.value = "";
    cardAmountStr.value = "";
    cashAmountStr.value = "";
    selectedPaymentOption.value = data;
    if(data == "Cash"){
      isSelectCashBox.value = true;
    }
    if(data == "Card"){
      isSelectCashBox.value = false;
    }
  }

  /// Called when a number button is tapped
  void setCalculate(String value, totalAmount) {
    print("selectedPayment.value -- ${selectedPayment.value}");
    if (value == "-1") {
      if (calculate.value.isNotEmpty) {
        calculate.value = calculate.value.substring(0, calculate.value.length - 1);
      }
    } else {
      calculate.value += value;
    }

    if(selectedPaymentOption.value == "Cash" && isSelectCashBox.value){
      cashAmountStr.value = calculate.value;
    }
    if(selectedPaymentOption.value == "Card" && isSelectCashBox.value == false){
      cardAmountStr.value = calculate.value;
    }

    if(selectedPaymentOption.value == "Split" && isSelectCashBox.value){
      cashAmountStr.value = calculate.value;
    }
    if(selectedPaymentOption.value == "Split" && isSelectCashBox.value == false){
      cardAmountStr.value = calculate.value;
    }

  }

  void updateCalculateFromBox() {
    if (selectedPaymentOption.value == "Split") {
      if (isSelectCashBox.value) {
        calculate.value = cashAmountStr.value;
      } else {
        calculate.value = cardAmountStr.value;
      }
    } else if (selectedPaymentOption.value == "Cash" && isSelectCashBox.value) {
      calculate.value = cashAmountStr.value;
    } else if (selectedPaymentOption.value == "Card" && isSelectCashBox.value == false) {
      calculate.value = cardAmountStr.value;
    }
  }

  void calculateBalance(double totalAmount) {
    double cash = double.tryParse(cashAmountStr.value) ?? 0.0;
    double card = double.tryParse(cardAmountStr.value) ?? 0.0;
    double totalPaid = cash + card;

    double difference = totalPaid - totalAmount;

    print("totalAmount -- ${totalAmount}");
    print("difference -- ${difference}");

    if (difference >= 0) {
      balanceAmount.value = difference.toStringAsFixed(2);
      balanceType.value = "Refund";
    } else {
      balanceAmount.value = (difference.abs()).toStringAsFixed(2);
      balanceType.value = "Remaining";
    }
  }


  void clearAll() {
    // Clear input & calculated values
    calculate.value = '';
    inputAmount.value = '';
    cashAmountStr.value = '';
    cardAmountStr.value = '';
    refundAmount.value = '';

    // Reset balance/remaining calculation
    balanceAmount.value = '0.00';
    balanceType.value = 'Remaining';

    // Reset selections
    selectedPaymentOption.value = 'Cash';
    isSelectCashBox.value = true;
    selectedPayment.value = 'Cash';
  }



  void updateInput(String value) {
    if (value == "-1") {
      if (inputAmount.value.isNotEmpty) {
        inputAmount.value = inputAmount.value.substring(0, inputAmount.value.length - 1);
      }
    } else {
      inputAmount.value += value;
    }
  }


  void reset() {
    inputAmount.value = '';

  }
}

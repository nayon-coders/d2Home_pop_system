import 'package:admin_desktop/src/core/constants/constants.dart';

import 'package:admin_desktop/src/core/handlers/handlers.dart';
import 'package:admin_desktop/src/models/models.dart';

abstract class OrdersRepository {
  Future<ApiResult<CreateOrderResponse>> createOrder(OrderBodyData orderBody);

  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    OrderStatus? status,
    int? page,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<ApiResult<dynamic>> updateOrderStatus({
    required OrderStatus status,
    int? orderId,
  });

  Future<ApiResult<dynamic>> updateOrderDetailStatus({
    required String status,
    int? orderId,
  });

  Future<ApiResult<dynamic>> updateOrderStatusKitchen({
    required OrderStatus status,
    int? orderId,
  });

  Future<ApiResult<SingleOrderResponse>> getOrderDetails({int? orderId});

  Future<ApiResult<SingleKitchenOrderResponse>> getOrderDetailsKitchen(
      {int? orderId});

  Future<ApiResult<dynamic>> setDeliverMan(
      {required int orderId, required int deliverymanId});

  Future<ApiResult<dynamic>> deleteOrder({required int orderId});

  Future<ApiResult<OrderKitchenResponse>> getKitchenOrders({
    String? status,
    int? page,
    String? search,
  });
}

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/models/response/product_calculate_response.dart';
import 'package:flutter/material.dart';

import 'package:admin_desktop/src/core/di/dependency_manager.dart';
import 'package:admin_desktop/src/core/handlers/handlers.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/models.dart';
import '../repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? query,
    int? categoryId,
    int? brandId,
    int? shopId,
    required int page,
  }) async {
    final data = {
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (shopId != null ||
          LocalStorage.getUser()?.role == TrKeys.waiter)
        'shop_id': LocalStorage.getUser()?.role == TrKeys.waiter
            ? LocalStorage.getUser()?.invite?.shopId
            : shopId,
      if (query != null) 'search': query,
      'perPage': 12,
      'page': page,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      "status": "published",
      "addon_status": "published"
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        LocalStorage.getUser()?.role == TrKeys.waiter
            ? '/api/v1/rest/products/paginate'
            : '/api/v1/dashboard/${LocalStorage.getUser()?.role}/products/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get products failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
      List<BagProductData> bagProducts, String type,
      {String? coupon}) async {
    UserData? userData = LocalStorage.getUser();
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency().id,
      'shop_id': userData?.role == TrKeys.waiter
          ? userData?.invite?.shopId ?? 0
          : userData?.shop?.id ?? 0,
      'type': type.isEmpty ? TrKeys.pickup : type,
      if (coupon != null) "coupon": coupon,
      'address[latitude]': LocalStorage
              .getBags()
              .first
              .selectedAddress
              ?.location
              ?.latitude ??
          0,
      'address[longitude]': LocalStorage
              .getBags()
              .first
              .selectedAddress
              ?.location
              ?.longitude ??
          0
    };
    for (int i = 0; i < (bagProducts.length); i++) {
      data['products[$i][stock_id]'] = bagProducts[i].stockId;
      data['products[$i][quantity]'] = bagProducts[i].quantity;
      for (int j = 0; j < (bagProducts[i].carts?.length ?? 0); j++) {
        data['products[$i][addons][$j][stock_id]'] = bagProducts[i].carts?[j].stockId;
        data['products[$i][addons][$j][quantity]'] = bagProducts[i].carts?[j].quantity;
      }
    }

    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/rest/order/products/calculate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all calculations failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}

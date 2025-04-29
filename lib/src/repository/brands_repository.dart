import 'package:admin_desktop/src/core/handlers/handlers.dart';
import 'package:admin_desktop/src/models/models.dart';

abstract class BrandsRepository {
  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String? query);
}

import 'package:admin_desktop/src/repository/discount_repository.dart';
import 'package:admin_desktop/src/repository/impl/discounts_repository_impl.dart';
import 'package:admin_desktop/src/repository/impl/notification_repo_impl.dart';
import 'package:admin_desktop/src/repository/impl/stock_repository_impl.dart';
import 'package:admin_desktop/src/repository/impl/stories_repository_impl.dart';
import 'package:admin_desktop/src/repository/impl/table_repository_iml.dart';
import 'package:admin_desktop/src/repository/notification_repository.dart';
import 'package:admin_desktop/src/repository/stock_repository.dart';
import 'package:admin_desktop/src/repository/stories_repository.dart';
import 'package:admin_desktop/src/repository/table_repository.dart';
import 'package:get_it/get_it.dart';
import '../../repository/impl/gallery_repository.dart';
import '../../repository/repository.dart';
import '../handlers/handlers.dart';

final GetIt getIt = GetIt.instance;

void setUpDependencies() {
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerSingleton<SettingsRepository>(SettingsSettingsRepositoryImpl());
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerSingleton<ProductsRepository>(ProductsRepositoryImpl());
  getIt.registerSingleton<ShopsRepository>(ShopsRepositoryImpl());
  getIt.registerSingleton<BrandsRepository>(BrandsRepositoryImpl());
  getIt.registerSingleton<GalleryRepositoryFacade>(GalleryRepository());
  getIt.registerSingleton<CategoriesRepository>(CategoriesRepositoryImpl());
  getIt.registerSingleton<CurrenciesRepository>(CurrenciesRepositoryImpl());
  getIt.registerSingleton<PaymentsRepository>(PaymentsRepositoryImpl());
  getIt.registerSingleton<OrdersRepository>(OrdersRepositoryImpl());
  getIt.registerSingleton<NotificationRepository>(NotificationRepositoryImpl());
  getIt.registerSingleton<UsersRepository>(UsersRepositoryImpl());
  getIt.registerSingleton<TableRepository>(TableRepositoryIml());
  getIt.registerSingleton<DiscountsRepository>(DiscountsRepositoryImpl());
  getIt.registerSingleton<StockRepository>(StockRepositoryImpl());
  getIt.registerSingleton<StoriesRepository>(StoriesRepositoryImpl());
}

final dioHttp = getIt.get<HttpService>();
final settingsRepository = getIt.get<SettingsRepository>();
final authRepository = getIt.get<AuthRepository>();
final productsRepository = getIt.get<ProductsRepository>();
final shopsRepository = getIt.get<ShopsRepository>();
final brandsRepository = getIt.get<BrandsRepository>();
final galleryRepository = getIt.get<GalleryRepositoryFacade>();
final categoriesRepository = getIt.get<CategoriesRepository>();
final currenciesRepository = getIt.get<CurrenciesRepository>();
final paymentsRepository = getIt.get<PaymentsRepository>();
final ordersRepository = getIt.get<OrdersRepository>();
final notificationRepository = getIt.get<NotificationRepository>();
final usersRepository = getIt.get<UsersRepository>();
final tableRepository = getIt.get<TableRepository>();
final discountRepository = getIt.get<DiscountsRepository>();
final stockRepository = getIt.get<StockRepository>();
final storiesRepository = getIt.get<StoriesRepository>();

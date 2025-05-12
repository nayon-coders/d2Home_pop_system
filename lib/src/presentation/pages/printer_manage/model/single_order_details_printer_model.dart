// To parse this JSON data, do
//
//     final singleOrderDetailsPrinterModel = singleOrderDetailsPrinterModelFromJson(jsonString);

import 'dart:convert';

SingleOrderDetailsPrinterModel singleOrderDetailsPrinterModelFromJson(String str) => SingleOrderDetailsPrinterModel.fromJson(json.decode(str));

String singleOrderDetailsPrinterModelToJson(SingleOrderDetailsPrinterModel data) => json.encode(data.toJson());

class SingleOrderDetailsPrinterModel {
  final DateTime? timestamp;
  final bool? status;
  final String? message;
  final Data? data;

  SingleOrderDetailsPrinterModel({
    this.timestamp,
    this.status,
    this.message,
    this.data,
  });

  factory SingleOrderDetailsPrinterModel.fromJson(Map<String, dynamic> json) => SingleOrderDetailsPrinterModel(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp?.toIso8601String(),
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final int? userId;
  final double? totalPrice;
  final double? originPrice;
  final double? sellerFee;
  final int? rate;
  final double? commissionFee;
  final double? serviceFee;
  final String? status;
  final DataLocation? location;
  final Address? address;
  final String? deliveryType;
  final int? deliveryFee;
  final DateTime? deliveryDate;
  final String? deliveryTime;
  final DateTime? deliveryDateTime;
  final String? phone;
  final int? otp;
  final bool? current;
  final int? split;
  final bool? paidBySplit;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? km;
  final dynamic deliveryman;
  final Shop? shop;
  final dynamic repeat;
  final Currency? currency;
  final User? user;
  final List<Detail>? details;
  final Transaction? transaction;
  final List<Transaction>? transactions;
  final dynamic review;
  final List<dynamic>? pointHistories;
  final List<dynamic>? orderRefunds;
  final dynamic coupon;
  final List<dynamic>? galleries;
  final dynamic myAddress;
  final dynamic table;
  final List<dynamic>? paymentProcesses;

  Data({
    this.id,
    this.userId,
    this.totalPrice,
    this.originPrice,
    this.sellerFee,
    this.rate,
    this.commissionFee,
    this.serviceFee,
    this.status,
    this.location,
    this.address,
    this.deliveryType,
    this.deliveryFee,
    this.deliveryDate,
    this.deliveryTime,
    this.deliveryDateTime,
    this.phone,
    this.otp,
    this.current,
    this.split,
    this.paidBySplit,
    this.createdAt,
    this.updatedAt,
    this.km,
    this.deliveryman,
    this.shop,
    this.repeat,
    this.currency,
    this.user,
    this.details,
    this.transaction,
    this.transactions,
    this.review,
    this.pointHistories,
    this.orderRefunds,
    this.coupon,
    this.galleries,
    this.myAddress,
    this.table,
    this.paymentProcesses,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    totalPrice: json["total_price"]?.toDouble(),
    originPrice: json["origin_price"]?.toDouble(),
    sellerFee: json["seller_fee"]?.toDouble(),
    rate: json["rate"],
    commissionFee: json["commission_fee"]?.toDouble(),
    serviceFee: json["service_fee"]?.toDouble(),
    status: json["status"],
    location: json["location"] == null ? null : DataLocation.fromJson(json["location"]),
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    deliveryType: json["delivery_type"],
    deliveryFee: json["delivery_fee"],
    deliveryDate: json["delivery_date"] == null ? null : DateTime.parse(json["delivery_date"]),
    deliveryTime: json["delivery_time"],
    deliveryDateTime: json["delivery_date_time"] == null ? null : DateTime.parse(json["delivery_date_time"]),
    phone: json["phone"],
    otp: json["otp"],
    current: json["current"],
    split: json["split"],
    paidBySplit: json["paid_by_split"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    km: json["km"],
    deliveryman: json["deliveryman"],
    shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
    repeat: json["repeat"],
    currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    details: json["details"] == null ? [] : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
    transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    review: json["review"],
    pointHistories: json["point_histories"] == null ? [] : List<dynamic>.from(json["point_histories"]!.map((x) => x)),
    orderRefunds: json["order_refunds"] == null ? [] : List<dynamic>.from(json["order_refunds"]!.map((x) => x)),
    coupon: json["coupon"],
    galleries: json["galleries"] == null ? [] : List<dynamic>.from(json["galleries"]!.map((x) => x)),
    myAddress: json["my_address"],
    table: json["table"],
    paymentProcesses: json["payment_processes"] == null ? [] : List<dynamic>.from(json["payment_processes"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "total_price": totalPrice,
    "origin_price": originPrice,
    "seller_fee": sellerFee,
    "rate": rate,
    "commission_fee": commissionFee,
    "service_fee": serviceFee,
    "status": status,
    "location": location?.toJson(),
    "address": address?.toJson(),
    "delivery_type": deliveryType,
    "delivery_fee": deliveryFee,
    "delivery_date": "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
    "delivery_time": deliveryTime,
    "delivery_date_time": deliveryDateTime?.toIso8601String(),
    "phone": phone,
    "otp": otp,
    "current": current,
    "split": split,
    "paid_by_split": paidBySplit,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "km": km,
    "deliveryman": deliveryman,
    "shop": shop?.toJson(),
    "repeat": repeat,
    "currency": currency?.toJson(),
    "user": user?.toJson(),
    "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x.toJson())),
    "transaction": transaction?.toJson(),
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "review": review,
    "point_histories": pointHistories == null ? [] : List<dynamic>.from(pointHistories!.map((x) => x)),
    "order_refunds": orderRefunds == null ? [] : List<dynamic>.from(orderRefunds!.map((x) => x)),
    "coupon": coupon,
    "galleries": galleries == null ? [] : List<dynamic>.from(galleries!.map((x) => x)),
    "my_address": myAddress,
    "table": table,
    "payment_processes": paymentProcesses == null ? [] : List<dynamic>.from(paymentProcesses!.map((x) => x)),
  };
}

class Address {
  final String? address;
  final dynamic office;
  final dynamic house;
  final dynamic floor;

  Address({
    this.address,
    this.office,
    this.house,
    this.floor,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    office: json["office"],
    house: json["house"],
    floor: json["floor"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "office": office,
    "house": house,
    "floor": floor,
  };
}

class Currency {
  final int? id;
  final String? symbol;
  final String? title;
  final int? rate;
  final bool? currencyDefault;
  final String? position;
  final bool? active;
  final DateTime? updatedAt;

  Currency({
    this.id,
    this.symbol,
    this.title,
    this.rate,
    this.currencyDefault,
    this.position,
    this.active,
    this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    symbol: json["symbol"],
    title: json["title"],
    rate: json["rate"],
    currencyDefault: json["default"],
    position: json["position"],
    active: json["active"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "title": title,
    "rate": rate,
    "default": currencyDefault,
    "position": position,
    "active": active,
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Detail {
  final int? id;
  final int? orderId;
  final int? stockId;
  final int? kitchenId;
  final double? originPrice;
  final double? totalPrice;
  final int? quantity;
  final String? status;
  final bool? bonus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? transactionStatus;
  final Kitchen? kitchen;
  final dynamic cooker;
  final Stock? stock;
  final List<Addon>? addons;

  Detail({
    this.id,
    this.orderId,
    this.stockId,
    this.kitchenId,
    this.originPrice,
    this.totalPrice,
    this.quantity,
    this.status,
    this.bonus,
    this.createdAt,
    this.updatedAt,
    this.transactionStatus,
    this.kitchen,
    this.cooker,
    this.stock,
    this.addons,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    orderId: json["order_id"],
    stockId: json["stock_id"],
    kitchenId: json["kitchen_id"],
    originPrice: json["origin_price"]?.toDouble(),
    totalPrice: json["total_price"]?.toDouble(),
    quantity: json["quantity"],
    status: json["status"],
    bonus: json["bonus"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    transactionStatus: json["transaction_status"],
    kitchen: json["kitchen"] == null ? null : Kitchen.fromJson(json["kitchen"]),
    cooker: json["cooker"],
    stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
    addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "stock_id": stockId,
    "kitchen_id": kitchenId,
    "origin_price": originPrice,
    "total_price": totalPrice,
    "quantity": quantity,
    "status": status,
    "bonus": bonus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "transaction_status": transactionStatus,
    "kitchen": kitchen?.toJson(),
    "cooker": cooker,
    "stock": stock?.toJson(),
    "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x.toJson())),
  };
}

class Addon {
  final int? id;
  final int? orderId;
  final int? stockId;
  final int? quantity;
  final String? status;
  final bool? bonus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? transactionStatus;
  final Stock? stock;
  final int? originPrice;
  final int? totalPrice;

  Addon({
    this.id,
    this.orderId,
    this.stockId,
    this.quantity,
    this.status,
    this.bonus,
    this.createdAt,
    this.updatedAt,
    this.transactionStatus,
    this.stock,
    this.originPrice,
    this.totalPrice,
  });

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    id: json["id"],
    orderId: json["order_id"],
    stockId: json["stock_id"],
    quantity: json["quantity"],
    status: json["status"],
    bonus: json["bonus"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    transactionStatus: json["transaction_status"],
    stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
    originPrice: json["origin_price"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "stock_id": stockId,
    "quantity": quantity,
    "status": status,
    "bonus": bonus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "transaction_status": transactionStatus,
    "stock": stock?.toJson(),
    "origin_price": originPrice,
    "total_price": totalPrice,
  };
}

class Stock {
  final int? id;
  final int? countableId;
  final int? quantity;
  final bool? addon;
  final List<dynamic>? extras;
  final Product? product;
  final dynamic price;
  final dynamic totalPrice;

  Stock({
    this.id,
    this.countableId,
    this.quantity,
    this.addon,
    this.extras,
    this.product,
    this.price,
    this.totalPrice,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    id: json["id"],
    countableId: json["countable_id"],
    quantity: json["quantity"],
    addon: json["addon"],
    extras: json["extras"] == null ? [] : List<dynamic>.from(json["extras"]!.map((x) => x)),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    price: json["price"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "countable_id": countableId,
    "quantity": quantity,
    "addon": addon,
    "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x)),
    "product": product?.toJson(),
    "price": price,
    "total_price": totalPrice,
  };
}

class Product {
  final int? id;
  final bool? active;
  final bool? addon;
  final bool? vegetarian;
  final int? costPrice;
  final List<dynamic>? discounts;
  final Translation? translation;
  final Unit? unit;
  final String? img;

  Product({
    this.id,
    this.active,
    this.addon,
    this.vegetarian,
    this.costPrice,
    this.discounts,
    this.translation,
    this.unit,
    this.img,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    active: json["active"],
    addon: json["addon"],
    vegetarian: json["vegetarian"],
    costPrice: json["cost_price"],
    discounts: json["discounts"] == null ? [] : List<dynamic>.from(json["discounts"]!.map((x) => x)),
    translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "addon": addon,
    "vegetarian": vegetarian,
    "cost_price": costPrice,
    "discounts": discounts == null ? [] : List<dynamic>.from(discounts!.map((x) => x)),
    "translation": translation?.toJson(),
    "unit": unit?.toJson(),
    "img": img,
  };
}

class Translation {
  final int? id;
  final String? locale;
  final String? title;
  final String? description;
  final String? address;

  Translation({
    this.id,
    this.locale,
    this.title,
    this.description,
    this.address,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
    id: json["id"],
    locale: json["locale"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "locale": locale,
    "title": title,
    "description": description,
    "address": address,
  };
}

class Unit {
  final int? id;
  final bool? active;
  final String? position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Translation? translation;

  Unit({
    this.id,
    this.active,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.translation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    active: json["active"],
    position: json["position"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "position": position,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translation": translation?.toJson(),
  };
}

class Kitchen {
  final int? id;
  final int? active;
  final int? shopId;
  final Translation? translation;

  Kitchen({
    this.id,
    this.active,
    this.shopId,
    this.translation,
  });

  factory Kitchen.fromJson(Map<String, dynamic> json) => Kitchen(
    id: json["id"],
    active: json["active"],
    shopId: json["shop_id"],
    translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "shop_id": shopId,
    "translation": translation?.toJson(),
  };
}

class DataLocation {
  final double? latitude;
  final double? longitude;

  DataLocation({
    this.latitude,
    this.longitude,
  });

  factory DataLocation.fromJson(Map<String, dynamic> json) => DataLocation(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Shop {
  final int? id;
  final String? uuid;
  final int? price;
  final int? pricePerKm;
  final int? tax;
  final String? phone;
  final bool? open;
  final bool? visibility;
  final dynamic verify;
  final bool? newOrderAfterPayment;
  final String? backgroundImg;
  final String? logoImg;
  final bool? isRecommended;
  final int? avgRate;
  final String? inviteLink;
  final ShopLocation? location;
  final int? productsCount;
  final Translation? translation;

  Shop({
    this.id,
    this.uuid,
    this.price,
    this.pricePerKm,
    this.tax,
    this.phone,
    this.open,
    this.visibility,
    this.verify,
    this.newOrderAfterPayment,
    this.backgroundImg,
    this.logoImg,
    this.isRecommended,
    this.avgRate,
    this.inviteLink,
    this.location,
    this.productsCount,
    this.translation,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json["id"],
    uuid: json["uuid"],
    price: json["price"],
    pricePerKm: json["price_per_km"],
    tax: json["tax"],
    phone: json["phone"],
    open: json["open"],
    visibility: json["visibility"],
    verify: json["verify"],
    newOrderAfterPayment: json["new_order_after_payment"],
    backgroundImg: json["background_img"],
    logoImg: json["logo_img"],
    isRecommended: json["is_recommended"],
    avgRate: json["avg_rate"],
    inviteLink: json["invite_link"],
    location: json["location"] == null ? null : ShopLocation.fromJson(json["location"]),
    productsCount: json["products_count"],
    translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "price": price,
    "price_per_km": pricePerKm,
    "tax": tax,
    "phone": phone,
    "open": open,
    "visibility": visibility,
    "verify": verify,
    "new_order_after_payment": newOrderAfterPayment,
    "background_img": backgroundImg,
    "logo_img": logoImg,
    "is_recommended": isRecommended,
    "avg_rate": avgRate,
    "invite_link": inviteLink,
    "location": location?.toJson(),
    "products_count": productsCount,
    "translation": translation?.toJson(),
  };
}

class ShopLocation {
  final String? latitude;
  final String? longitude;

  ShopLocation({
    this.latitude,
    this.longitude,
  });

  factory ShopLocation.fromJson(Map<String, dynamic> json) => ShopLocation(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Transaction {
  final int? id;
  final int? payableId;
  final double? price;
  final String? note;
  final DateTime? performTime;
  final String? status;
  final String? statusDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PaymentSystem? paymentSystem;
  final dynamic paymentProcess;
  final List<dynamic>? children;

  Transaction({
    this.id,
    this.payableId,
    this.price,
    this.note,
    this.performTime,
    this.status,
    this.statusDescription,
    this.createdAt,
    this.updatedAt,
    this.paymentSystem,
    this.paymentProcess,
    this.children,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    payableId: json["payable_id"],
    price: json["price"]?.toDouble(),
    note: json["note"],
    performTime: json["perform_time"] == null ? null : DateTime.parse(json["perform_time"]),
    status: json["status"],
    statusDescription: json["status_description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    paymentSystem: json["payment_system"] == null ? null : PaymentSystem.fromJson(json["payment_system"]),
    paymentProcess: json["payment_process"],
    children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "payable_id": payableId,
    "price": price,
    "note": note,
    "perform_time": performTime?.toIso8601String(),
    "status": status,
    "status_description": statusDescription,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "payment_system": paymentSystem?.toJson(),
    "payment_process": paymentProcess,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
  };
}

class PaymentSystem {
  final int? id;
  final String? tag;
  final int? input;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentSystem({
    this.id,
    this.tag,
    this.input,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentSystem.fromJson(Map<String, dynamic> json) => PaymentSystem(
    id: json["id"],
    tag: json["tag"],
    input: json["input"],
    active: json["active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag": tag,
    "input": input,
    "active": active,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  final int? id;
  final String? uuid;
  final String? firstname;
  final String? lastname;
  final bool? emptyP;
  final String? email;
  final int? isWork;
  final String? phone;
  final String? gender;
  final int? active;
  final String? myReferral;
  final String? role;
  final DateTime? emailVerifiedAt;
  final DateTime? registeredAt;
  final double? ordersSumPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? ordersCount;

  User({
    this.id,
    this.uuid,
    this.firstname,
    this.lastname,
    this.emptyP,
    this.email,
    this.isWork,
    this.phone,
    this.gender,
    this.active,
    this.myReferral,
    this.role,
    this.emailVerifiedAt,
    this.registeredAt,
    this.ordersSumPrice,
    this.createdAt,
    this.updatedAt,
    this.ordersCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    uuid: json["uuid"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    emptyP: json["empty_p"],
    email: json["email"],
    isWork: json["isWork"],
    phone: json["phone"],
    gender: json["gender"],
    active: json["active"],
    myReferral: json["my_referral"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    registeredAt: json["registered_at"] == null ? null : DateTime.parse(json["registered_at"]),
    ordersSumPrice: json["orders_sum_price"]?.toDouble(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ordersCount: json["orders_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "firstname": firstname,
    "lastname": lastname,
    "empty_p": emptyP,
    "email": email,
    "isWork": isWork,
    "phone": phone,
    "gender": gender,
    "active": active,
    "my_referral": myReferral,
    "role": role,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "registered_at": registeredAt?.toIso8601String(),
    "orders_sum_price": ordersSumPrice,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "orders_count": ordersCount,
  };
}

class ApiEndpoints {
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/ktpl/account/login?___store=en';
  static const String logout = '/ktpl/account/logout?___store=en';

  // Products
  static const String products =
      '/ktpl/getCategoryProducts?___store=en&list_type=3&currency_code=SAR';

  static const String relatedProducts =
      '/ktpl/product/related?___store=en&currency_code=SAR';

  static const String productDetails =
      '/ktpl/getProduct?___store=en&currency_code=SAR&version_number=167';
}

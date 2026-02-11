class Constants {
  Constants._();

  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
  static const String tenantId = String.fromEnvironment('TENANT_ID', defaultValue: '');
  static const String categoryOil = String.fromEnvironment('CATEGORY_OIL', defaultValue: '');
}

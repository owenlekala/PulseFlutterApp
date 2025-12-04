import 'api_config.dart';

class ApiEndpoints {
  // Authentication endpoints
  static String get login => '${ApiConfig.fullBaseUrl}/auth/login';
  static String get register => '${ApiConfig.fullBaseUrl}/auth/register';
  static String get logout => '${ApiConfig.fullBaseUrl}/auth/logout';
  static String get refreshToken => '${ApiConfig.fullBaseUrl}/auth/refresh';
  static String get forgotPassword => '${ApiConfig.fullBaseUrl}/auth/forgot-password';
  static String get resetPassword => '${ApiConfig.fullBaseUrl}/auth/reset-password';

  // User endpoints
  static String get userProfile => '${ApiConfig.fullBaseUrl}/user/profile';
  static String updateUser(String userId) => '${ApiConfig.fullBaseUrl}/user/$userId';
  static String deleteUser(String userId) => '${ApiConfig.fullBaseUrl}/user/$userId';

  // Example resource endpoints (customize as needed)
  static String get items => '${ApiConfig.fullBaseUrl}/items';
  static String item(String id) => '${ApiConfig.fullBaseUrl}/items/$id';
  static String itemComments(String itemId) => '${ApiConfig.fullBaseUrl}/items/$itemId/comments';
}


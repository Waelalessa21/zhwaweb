class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';

  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String registerEndpoint = '/auth/register';

  static const String storesEndpoint = '/stores';
  static const String offersEndpoint = '/offers';
  static const String subscriptionsEndpoint = '/subscriptions';
  static const String uploadEndpoint = '/upload/image';
  static const String dashboardEndpoint = '/dashboard/stats';

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}


//get post put delete
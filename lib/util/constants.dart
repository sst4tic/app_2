
class Constants {
  static const String API_URL_DOMAIN = 'https://yiwumart.org/api/v2/core?';
  static const String BASE_URL_DOMAIN = 'https://yiwumart.org';
  static const String BASE_URL_CATALOG_DOMAIN = 'https://cdn.yiwumart.org/';
  static String USER_TOKEN = '';
  static String header = 'Authorization';
  static String bearer = '';
  static String cookie = '';
  static String useragent = '';
  static headers() => {header: bearer, 'Cookie': cookie, 'user-agent': 'YiwuMart: $useragent'};
}
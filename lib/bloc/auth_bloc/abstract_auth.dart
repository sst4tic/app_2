
abstract class AbstractAuth {
  getToken();
  getCookie();
  getFirebaseToken();
  Future<void> logout();
  Future loginSms(String phone, context);
  Future checkSmsCode(String phone, String code);
  Future login(String email, String password, context);
  Future register(String email, String password, String name, String surname, context);
}
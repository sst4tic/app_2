
abstract class AbstractAuth {
  getToken();
  getCookie();
  getFirebaseToken();
  Future<void> logout();
  Future login(String email, String password, context);
  Future register(String email, String password, String name, String surname, context);
}
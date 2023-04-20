
 import '../../util/user.dart';

abstract class AbstractEdit {
  Future getProfile();
  Future editProfile(User user);
  Future deleteAccount();
 }
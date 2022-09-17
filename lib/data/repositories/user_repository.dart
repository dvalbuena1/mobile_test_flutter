import 'package:mobile_test_flutter/data/dao/local_storage/local_storage_user.dart';
import 'package:mobile_test_flutter/data/models/user.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class UserRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();
  final LocalStorageUser localStorageUser = LocalStorageUser();

  Future<UserModel?> getUserOnline(int userId) async {
    UserModel? dbUser = await localStorageUser.selectById(userId);
    if (dbUser != null) {
      return dbUser;
    } else {
      UserModel? apiUser = await apiJsonPlaceholder.getUser(userId);
      if (apiUser != null) {
        localStorageUser.insert(apiUser);
      }
      return apiUser;
    }
  }

  Future<UserModel?> getUserOffline(int userId) async {
    UserModel? dbUser = await localStorageUser.selectById(userId);
    return dbUser;
  }
}

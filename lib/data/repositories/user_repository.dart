import 'package:mobile_test_flutter/data/models/user.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class UserRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();

  Future<UserModel?> getUser(int userId) async {
    return await apiJsonPlaceholder.getUser(userId);
  }
}

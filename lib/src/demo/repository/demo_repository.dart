import '../../networking/api_constant.dart';

import '../../networking/api_manager.dart';
import '../models/user_list_dto.dart';

class DemoRepository {
  static Future<UserListDto> fetchUsers() async {
    try {
      final response = await ApiManager().get(ApiConstant.userList);
      final userListDto = UserListDto.fromJson(response);
      return userListDto;
    } catch (e) {
      rethrow;
    }
  }
}

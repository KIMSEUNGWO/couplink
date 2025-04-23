
import 'package:couplink_app/api/UserService.dart';
import 'package:couplink_app/entity/User.dart';
import 'package:couplink_app/service/NetworkService.dart';
import 'package:riverpod/riverpod.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  init() async {
    final isOnline = await NetworkService().isOnline();
    if (!isOnline) {

      return;
    }

    var response = await UserService().readUser();

  }

  bool isLogin() {
    return state != null;
  }


}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier(),);
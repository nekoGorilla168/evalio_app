import 'package:evalio_app/dao/user-dao.dart';
import 'package:evalio_app/models/user_model.dart';

class AuthRepository {
  final userDao = UserDao();

  Future insertUser(UserModel userModel) => userDao.insertUserInfo(userModel);
}

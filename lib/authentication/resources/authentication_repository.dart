import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/services/authentication_services.dart';

class AuthenticationRepository {
  final AuthenticationFishBackEnd _authenticationFishBackEnd =
      AuthenticationFishBackEnd();

  Future<User> logIn(String user, String password) =>
      _authenticationFishBackEnd.logIn(user, password);

  Future<List<AccessByRole>> fetchAccessByRole(Role role) =>
      _authenticationFishBackEnd.fetchAccessByRole(role);
}

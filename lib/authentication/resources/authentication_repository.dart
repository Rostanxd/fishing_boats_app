import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/services/authentication_services.dart';

class AuthenticationRepository {
  final AuthenticationFishBackEnd _authenticationFishBackEnd =
      AuthenticationFishBackEnd();

  Future<User> logIn(String user, String password, String deviceId) =>
      _authenticationFishBackEnd.logIn(user, password, deviceId);

  Future<void> logOut(String user, String deviceId) =>
      _authenticationFishBackEnd.logOut(user, deviceId);

  Future<User> authenticatedUser(String deviceId) =>
      _authenticationFishBackEnd.authenticatedUser(deviceId);

  Future<List<AccessByRole>> fetchAccessByRole(Role role) =>
      _authenticationFishBackEnd.fetchAccessByRole(role);
}

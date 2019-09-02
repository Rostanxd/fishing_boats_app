import 'package:device_info/device_info.dart';
import 'package:fishing_boats_app/authentication/models/role.dart';
import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/resources/authentication_repository.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends Object implements BlocBase {
  final _user = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _logging = BehaviorSubject<bool>();
  final _userLogged = BehaviorSubject<User>();
  final _deviceId = BehaviorSubject<String>();
  final _message = BehaviorSubject<String>();
  final _accessByRole = BehaviorSubject<List<AccessByRole>>();
  final _androidDeviceInfo = BehaviorSubject<AndroidDeviceInfo>();
  final _iosDeviceInfo = BehaviorSubject<IosDeviceInfo>();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Observables
  Stream<String> get user => _user.stream;

  Stream<String> get password => _password.stream;

  Stream<bool> get logging => _logging.stream;

  ValueObservable<User> get userLogged => _userLogged.stream;

  Observable<List<AccessByRole>> get accessByRole => _accessByRole.stream;

  Observable<String> get messenger => _message.stream;

  Observable<String> get deviceId => _deviceId.stream;

  Stream<bool> get validForm =>
      Observable.combineLatest2(user, password, (a, b) {
        if (a != null && b != null) return true;
        return false;
      });

  /// Functions
  Function(String) get changeMessage => _message.add;

  Function(String) get changeDeviceId => _deviceId.add;

  void changeUser(value) {
    if (value == '') return _user.sink.add(null);
    _user.sink.add(value);
  }

  void changePassword(value) {
    if (value == '') return _password.sink.add(null);
    _password.sink.add(value);
  }

  Future<void> logIn() async {
    User userValid;
    _logging.sink.add(true);
    await _authenticationRepository
        .logIn(_user.value, _password.value, _deviceId.value)
        .then((user) {
          if (user == null)
            return _message.sink.add('Error: Usuario o clave incorrecta.');
          if (user.role == null)
            return _message.sink.add('Usuario sin rol asignado');

          userValid = user;
        })
        .timeout(Duration(seconds: 15))
        .catchError((error) {
          _message.sink.add('Error: ${error.toString()}');
          _logging.sink.add(false);
        });

    await _fetchAccessByRole(userValid).then((v) {
      _userLogged.sink.add(userValid);
    });
    _logging.sink.add(false);
  }

  Future<void> logOut() async {
    _authenticationRepository
        .logOut(_userLogged.value.code, _deviceId.value)
        .then((v) => _userLogged.sink.add(null));
  }

  Future<void> _fetchAccessByRole(User user) async {
    await _authenticationRepository.fetchAccessByRole(user.role).then((access) {
      _accessByRole.sink.add(access);
    });
  }

  Future<void> fetchDeviceInfo(bool isAndroid) async {
    User userValid;
    if (isAndroid) {
      await _deviceInfoPlugin.androidInfo.then((info) {
        _androidDeviceInfo.sink.add(info);
        _deviceId.sink.add(info.androidId);
      });
    } else {
      await _deviceInfoPlugin.iosInfo.then((info) {
        _iosDeviceInfo.sink.add(info);
        _deviceId.sink.add(info.identifierForVendor);
      });
    }

    await _authenticationRepository
        .authenticatedUser(_deviceId.value)
        .then((value) {
          userValid = value;
        })
        .timeout(Duration(seconds: 15))
        .catchError((error) {
          _userLogged.addError(error);
        });

    await _fetchAccessByRole(userValid).then((v) {
      _userLogged.sink.add(userValid);
    });
  }

  @override
  void dispose() {
    _user.close();
    _password.close();
    _userLogged.close();
    _accessByRole.close();
    _message.close();
    _logging.close();
    _deviceId.close();
    _androidDeviceInfo.close();
    _iosDeviceInfo.close();
  }
}

import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/resources/authentication_repository.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends Object implements BlocBase {
  final _user = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _logging = BehaviorSubject<bool>();
  final _userLogged = BehaviorSubject<User>();
  final _message = BehaviorSubject<String>();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  /// Observables
  Stream<String> get user => _user.stream;

  Stream<String> get password => _password.stream;

  Stream<bool> get logging => _logging.stream;

  ValueObservable<User> get userLogged => _userLogged.stream;

  Observable<String> get messenger => _message.stream;

  Stream<bool> get validForm =>
      Observable.combineLatest2(user, password, (a, b) {
        if (a != null && b != null) return true;
        return false;
      });

  /// Functions
  void changeUser(value) {
    if (value == '') return _user.sink.add(null);
    _user.sink.add(value);
  }

  void changePassword(value) {
    if (value == '') return _password.sink.add(null);
    _password.sink.add(value);
  }

  Future<void> logIn() async {
    _logging.sink.add(true);
    await _authenticationRepository
        .logIn(_user.value, _password.value)
        .then((user) {
          if (user != null) return _userLogged.sink.add(user);
          return _message.sink.add('Error: Usuario o clave incorrecta.');
        })
        .timeout(Duration(seconds: 15))
        .catchError((error) {
          _message.sink.add('Error: ${error.toString()}');
          _logging.sink.add(false);
        });
    _logging.sink.add(false);
  }

  Future<void> logOut() async {
    _userLogged.sink.add(null);
  }

  @override
  void dispose() {
    _user.close();
    _password.close();
    _userLogged.close();
    _message.close();
    _logging.close();
  }
}

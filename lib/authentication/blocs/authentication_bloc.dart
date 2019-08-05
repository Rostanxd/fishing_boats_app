import 'package:fishing_boats_app/authentication/models/user.dart';
import 'package:fishing_boats_app/authentication/resources/authentication_repository.dart';
import 'package:fishing_boats_app/models/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends Object implements BlocBase {
  final _user = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _logging = BehaviorSubject<bool>();
  final _userLogged = BehaviorSubject<User>();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  /// Observables
  Stream<String> get user => _user.stream;

  Stream<String> get password => _password.stream;

  Stream<bool> get logging => _logging.stream;

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
      _userLogged.sink.add(user);
      print(user.toString());
    }).catchError((error){
      print(error.toString());
      _logging.sink.add(false);
    });
    _logging.sink.add(false);
  }

  @override
  void dispose() {
    _user.close();
    _password.close();
    _userLogged.close();
    _logging.close();
  }
}

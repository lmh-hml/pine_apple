import 'package:pine_apple/model/auth_service.dart';
import 'package:pine_apple/screen/screen.dart';
import '../import_firebase.dart';

class SettingsController
{
  AuthService authService;
  SettingsController(this.authService);

  ///Called by UI upon a logout event.
  Future<void> logout(BuildContext context) async
  {
    await authService.signOut();
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.START_UP));
  }
}
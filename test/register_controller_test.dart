
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as FirebaseMock;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pine_apple/controller/register_page_controller.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/auth_service.dart';

class MockAuthService extends Mock implements AuthService{}
class MockDatabase extends Mock implements DatabaseReference{}

void main()
{
  FirebaseMock.MockFirebaseAuth mockFB = FirebaseMock.MockFirebaseAuth();


  AuthService auth = AuthService(firebaseAuth: mockFB,databaseReference: MockDatabase());
  RegisterController registerController = RegisterController(auth);


  Stream<String> errorStream = registerController.errorStream;

  test("Testing controller inputs", ()async{

    User user = await registerController.onSignUpPressed(username: '',email: '',password: '');
    expect(user, null);
    expect(registerController.lastErrorString, RegisterController.usernameBlankText);

    await registerController.onSignUpPressed(username: 'user',email: '',password: '');
    expect(registerController.lastErrorString, RegisterController.userNameInvalidText);

    await registerController.onSignUpPressed(username: 'username1', email: '', password: '');
    expect(registerController.lastErrorString, RegisterController.emailBlankText);

    await registerController.onSignUpPressed(username: 'username1', email: 'email@email.com', password: '');
    expect(registerController.lastErrorString, RegisterController.pwdBlankText);

    await registerController.onSignUpPressed(username: 'username1', email: 'email@email.com', password: 'pass');
    expect(registerController.lastErrorString, RegisterController.pwdInvalidText);

  });
}
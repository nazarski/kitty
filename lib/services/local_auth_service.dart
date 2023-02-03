import 'package:local_auth/local_auth.dart';
class LocalAuth{
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate()async{
    final supported = await _auth.isDeviceSupported();
    final canCheck = await _auth.canCheckBiometrics;
    return supported && canCheck;
  }
  static Future<bool> authenticate()async{
    return await _auth.authenticate(
        localizedReason: 'Please authenticate',
      options: const AuthenticationOptions(
          stickyAuth:  true,
          biometricOnly: true,
      )
    );
  }


}
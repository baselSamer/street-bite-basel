import 'package:local_auth/local_auth.dart';
import '../../../domain/repositories/profile_unlock_service.dart';

/// Uses enrolled biometrics when the device provides them. Unsupported devices
/// remain able to open the mandatory profile features.
class BiometricProfileService implements ProfileUnlockService {
  final LocalAuthentication _auth;

  const BiometricProfileService(this._auth);

  @override
  Future<ProfileUnlockResult> unlock(String reason) async {
    try {
      final enrolled = await _auth.getAvailableBiometrics();
      if (enrolled.isEmpty) return ProfileUnlockResult.unavailable;
      final granted = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      return granted ? ProfileUnlockResult.granted : ProfileUnlockResult.denied;
    } catch (_) {
      return ProfileUnlockResult.denied;
    }
  }
}

import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInfrastructureConfigRepository
    extends InfrastructureConfigRepository {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    final result = await FirebaseAuth.instance.signInAnonymously();
    print(result.user);
    return;
  }
}

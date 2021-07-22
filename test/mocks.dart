import 'package:clubedematematica/app/shared/repositories/firebase/auth_repository.dart';
import 'package:mockito/mockito.dart';

/// Mock para a classe [AuthRepository].
class MockAuthRepository extends Fake implements AuthRepository {
  @override
  bool get connected => true;

}

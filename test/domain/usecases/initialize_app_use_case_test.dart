import 'package:compare_prices/domain/usecases/initialize_app_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generate.mocks.dart';

void main() {
  group('InitializeAppUseCase', () {
    group('call', () {
      test('初期化処理が呼ばれること', () async {
        final infrastructureConfigRepository =
            MockInfrastructureConfigRepository();

        final container = getDisposableProviderContainer(
            infrastructureConfigRepository: infrastructureConfigRepository);
        final useCase = InitializeAppUseCase(container.read);

        await useCase(NoParam());

        verify(infrastructureConfigRepository.initialize()).called(1);
      });
    });
  });
}

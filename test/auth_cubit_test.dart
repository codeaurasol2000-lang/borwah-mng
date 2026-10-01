import 'package:barwah_app/features/auth/domain/entities/user_role.dart';
import 'package:barwah_app/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:barwah_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthCubit email role resolution', () {
    final accounts = <String, UserRole>{
      'admin': UserRole.admin,
      'head': UserRole.headOfSupervisors,
      'merchant': UserRole.merchantSupervisor,
      'wasalny': UserRole.wasalnySupervisor,
      'services': UserRole.servicesSupervisor,
      'products': UserRole.productSupervisor,
      'finance': UserRole.financialSupervisor,
    };

    for (final entry in accounts.entries) {
      test('${entry.key} prefix resolves to ${entry.value.name}', () async {
        final cubit = AuthCubit();
        await cubit.login('${entry.key}@example.com', 'password');

        expect(cubit.state, isA<AuthSuccess>());
        expect((cubit.state as AuthSuccess).user.role, entry.value);
        await cubit.close();
      });
    }

    test('unknown prefix is rejected', () async {
      final cubit = AuthCubit();
      await cubit.login('unknown@example.com', 'password');

      expect(cubit.state, isA<AuthError>());
      await cubit.close();
    });
  });
}

import 'package:barwah_app/features/finance/data/datasources/finance_mock_data_source.dart';
import 'package:barwah_app/features/finance/domain/entities/expense_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FinanceMockDataSource expense requests', () {
    late FinanceMockDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      dataSource = FinanceMockDataSource();
    });

    test('records a pending request and preserves the bank balance', () async {
      final accountsBefore = await dataSource.getBankAccounts();
      final account = accountsBefore.first;

      final request = await dataSource.submitExpenseRequest(
        amount: 1250.5,
        bankAccountId: account.id,
        reason: 'Office supplies',
      );

      final requests = await dataSource.getExpenseRequests();
      final accountsAfter = await dataSource.getBankAccounts();

      expect(request.status, ExpenseRequestStatus.pendingAdminApproval);
      expect(request.amount, 1250.5);
      expect(request.bankAccountId, account.id);
      expect(request.bankName, account.bankName);
      expect(request.reason, 'Office supplies');
      expect(requests, [request]);
      expect(accountsAfter.first.balance, account.balance);
    });

    test('rejects invalid amounts and missing reasons', () async {
      await expectLater(
        dataSource.submitExpenseRequest(
          amount: 0,
          bankAccountId: 'acc_01',
          reason: 'Valid reason',
        ),
        throwsA(isA<ArgumentError>()),
      );
      await expectLater(
        dataSource.submitExpenseRequest(
          amount: 10,
          bankAccountId: 'acc_01',
          reason: '   ',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects an unknown bank account', () async {
      await expectLater(
        dataSource.submitExpenseRequest(
          amount: 10,
          bankAccountId: 'missing-account',
          reason: 'Valid reason',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}

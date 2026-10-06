import 'package:barwah_app/features/finance/data/datasources/finance_mock_data_source.dart';
import 'package:barwah_app/features/finance/domain/entities/bank_account_edit_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinanceMockDataSource bank account edit requests', () {
    late FinanceMockDataSource dataSource;

    setUp(() {
      dataSource = FinanceMockDataSource();
    });

    test('submits a pending request without changing the approved account',
        () async {
      final accountBefore = (await dataSource.getBankAccounts()).first;

      final request = await dataSource.submitBankAccountEditRequest(
        accountId: accountBefore.id,
        proposedBankName: 'Updated bank',
        proposedAccountType: 'Operational account',
        proposedIban: 'EG123456789',
      );

      final accountAfter = (await dataSource.getBankAccounts()).first;
      final requests = await dataSource.getBankAccountEditRequests();

      expect(request.status, BankAccountEditRequestStatus.pending);
      expect(request.bankName, accountBefore.bankName);
      expect(request.proposedBankName, 'Updated bank');
      expect(requests, [request]);
      expect(accountAfter, accountBefore);
    });

    test('rejects incomplete proposed account details', () async {
      await expectLater(
        dataSource.submitBankAccountEditRequest(
          accountId: 'acc_01',
          proposedBankName: '',
          proposedAccountType: 'Operational account',
          proposedIban: 'EG123456789',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects requests that do not change any account details', () async {
      final account = (await dataSource.getBankAccounts()).first;

      await expectLater(
        dataSource.submitBankAccountEditRequest(
          accountId: account.id,
          proposedBankName: account.bankName,
          proposedAccountType: account.accountType,
          proposedIban: account.iban,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('prevents a second pending request for the same account', () async {
      await dataSource.submitBankAccountEditRequest(
        accountId: 'acc_01',
        proposedBankName: 'Updated bank',
        proposedAccountType: 'Operational account',
        proposedIban: 'EG123456789',
      );

      await expectLater(
        dataSource.submitBankAccountEditRequest(
          accountId: 'acc_01',
          proposedBankName: 'Another bank',
          proposedAccountType: 'Operational account',
          proposedIban: 'EG987654321',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}

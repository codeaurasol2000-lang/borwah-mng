import 'package:barwah_app/features/finance/data/datasources/finance_mock_data_source.dart';
import 'package:barwah_app/features/finance/domain/entities/withdrawal_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinanceMockDataSource frozen withdrawals', () {
    late FinanceMockDataSource dataSource;

    setUp(() {
      dataSource = FinanceMockDataSource();
    });

    test('returns only frozen and under-investigation withdrawals', () async {
      final requests = await dataSource.getFrozenWithdrawals();

      expect(requests, hasLength(3));
      expect(
        requests.every((request) =>
            request.status == RequestStatus.frozen ||
            request.status == RequestStatus.underInvestigation),
        isTrue,
      );
    });

    test('restores a held request to pending and removes it from this queue',
        () async {
      final request = (await dataSource.getFrozenWithdrawals()).first;
      final balancesBefore = (await dataSource.getBankAccounts())
          .map((account) => account.balance)
          .toList();

      await dataSource.restoreFrozenWithdrawal(
          request.id, request.beneficiaryType);

      final requestsAfter = await dataSource.getFrozenWithdrawals();
      final allWithdrawals = [
        ...await dataSource.getMerchantWithdrawals(),
        ...await dataSource.getSupervisorWithdrawals(),
      ];
      final restored = allWithdrawals.singleWhere(
        (item) =>
            item.id == request.id &&
            item.beneficiaryType == request.beneficiaryType,
      );

      expect(restored.status, RequestStatus.pending);
      expect(requestsAfter, hasLength(2));
      expect(
        (await dataSource.getBankAccounts())
            .map((account) => account.balance)
            .toList(),
        balancesBefore,
      );
    });

    test('rejects and stores the forfeiture reason', () async {
      final request = (await dataSource.getFrozenWithdrawals()).first;
      final balancesBefore = (await dataSource.getBankAccounts())
          .map((account) => account.balance)
          .toList();
      const reason = 'Confirmed financial policy violation';

      await dataSource.rejectAndForfeitWithdrawal(
        request.id,
        request.beneficiaryType,
        reason,
      );

      final allWithdrawals = [
        ...await dataSource.getMerchantWithdrawals(),
        ...await dataSource.getSupervisorWithdrawals(),
      ];
      final rejected = allWithdrawals.singleWhere(
        (item) =>
            item.id == request.id &&
            item.beneficiaryType == request.beneficiaryType,
      );

      expect(rejected.status, RequestStatus.rejected);
      expect(rejected.alertNotice, reason);
      expect(await dataSource.getFrozenWithdrawals(), hasLength(2));
      expect(
        (await dataSource.getBankAccounts())
            .map((account) => account.balance)
            .toList(),
        balancesBefore,
      );
    });

    test('requires a reason before rejecting and forfeiting', () async {
      final request = (await dataSource.getFrozenWithdrawals()).first;

      await expectLater(
        dataSource.rejectAndForfeitWithdrawal(
            request.id, request.beneficiaryType, '   '),
        throwsA(isA<ArgumentError>()),
      );
      expect(await dataSource.getFrozenWithdrawals(), hasLength(3));
    });

    test('does not restore an already resolved request', () async {
      final request = (await dataSource.getFrozenWithdrawals()).first;
      await dataSource.restoreFrozenWithdrawal(
          request.id, request.beneficiaryType);

      await expectLater(
        dataSource.restoreFrozenWithdrawal(request.id, request.beneficiaryType),
        throwsA(isA<StateError>()),
      );
    });
  });
}

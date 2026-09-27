import 'package:get_it/get_it.dart';

import '../../features/finance/data/datasources/finance_mock_data_source.dart';
import '../../features/finance/data/datasources/finance_remote_data_source.dart';
import '../../features/finance/data/repositories/finance_repository_impl.dart';
import '../../features/finance/domain/repositories/finance_repository.dart';
import '../../features/finance/domain/usecases/get_bank_accounts_usecase.dart';
import '../../features/finance/domain/usecases/get_finance_summary_usecase.dart';
import '../../features/finance/domain/usecases/get_merchant_withdrawals_usecase.dart';
import '../../features/finance/domain/usecases/get_subscriptions_usecase.dart';
import '../../features/finance/domain/usecases/get_supervisor_withdrawals_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data Sources (تبديل هذا السطر فقط بالـ Api DataSource عند استلام الـ API)
  sl.registerLazySingleton<FinanceRemoteDataSource>(() => FinanceMockDataSource());

  // Repositories
  sl.registerLazySingleton<FinanceRepository>(
        () => FinanceRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetFinanceSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetBankAccountsUseCase(sl()));
  sl.registerLazySingleton(() => GetMerchantWithdrawalsUseCase(sl()));
  sl.registerLazySingleton(() => GetSupervisorWithdrawalsUseCase(sl()));
  sl.registerLazySingleton(() => GetSubscriptionsUseCase(sl()));
}
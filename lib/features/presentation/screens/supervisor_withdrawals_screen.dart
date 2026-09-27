import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/withdrawal_request_entity.dart';
import '../../finance/domain/usecases/get_supervisor_withdrawals_usecase.dart';

class SupervisorWithdrawalsScreen extends StatefulWidget {
  const SupervisorWithdrawalsScreen({super.key});

  @override
  State<SupervisorWithdrawalsScreen> createState() => _SupervisorWithdrawalsScreenState();
}

class _SupervisorWithdrawalsScreenState extends State<SupervisorWithdrawalsScreen> {
  List<WithdrawalRequestEntity> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetSupervisorWithdrawalsUseCase>()();
    result.fold(
          (failure) => setState(() => _isLoading = false),
          (data) => setState(() {
        _requests = data;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('طلبات سحب مستحقات المشرفين ومقدمي الخدمة', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._requests.map((req) => _buildSupervisorCard(req)).toList(),
        ],
      ),
    );
  }

  Widget _buildSupervisorCard(WithdrawalRequestEntity req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: Text('#${req.requestNumber}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(req.beneficiaryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(req.beneficiaryRole, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CurrencyFormatter.format(req.netAmount), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const Text('صافي المبلغ المستحق للصرف', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(req.dateText, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: const Text('اعتماد وإرسال الطلب للإدارة', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
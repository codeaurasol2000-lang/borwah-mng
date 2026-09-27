import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/withdrawal_request_entity.dart';
import '../../finance/domain/usecases/get_merchant_withdrawals_usecase.dart';

class MerchantWithdrawalsScreen extends StatefulWidget {
  const MerchantWithdrawalsScreen({super.key});

  @override
  State<MerchantWithdrawalsScreen> createState() => _MerchantWithdrawalsScreenState();
}

class _MerchantWithdrawalsScreenState extends State<MerchantWithdrawalsScreen> {
  List<WithdrawalRequestEntity> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetMerchantWithdrawalsUseCase>()();
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
        title: const Text('طلبات سحب مستحقات التجار والمستخدمين', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إحصائية علوية
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard('الطلبات المعلقة', '14', '56,200 ر.س', Icons.pending_actions, AppColors.info),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricMiniCard('تحت الاحتراز', '6', 'تجميد رقابي', Icons.gavel, AppColors.danger),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._requests.map((req) => _buildWithdrawalCard(req)).toList(),
        ],
      ),
    );
  }

  Widget _buildMetricMiniCard(String title, String count, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildWithdrawalCard(WithdrawalRequestEntity req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: req.status == RequestStatus.underInvestigation ? AppColors.danger.withOpacity(0.3) : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
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
              Text(CurrencyFormatter.format(req.grossAmount), style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: AppColors.textMuted)),
              const Text('إجمالي المبلغ المطلوب', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(req.netAmount),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
              const Text('صافي المبلغ المحول للحساب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          if (req.alertNotice != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(req.alertNotice!, style: const TextStyle(fontSize: 11, color: AppColors.danger, height: 1.4), textAlign: TextAlign.right),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: req.status == RequestStatus.underInvestigation ? AppColors.danger : AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text(
                    req.status == RequestStatus.underInvestigation ? 'الرفض وإشعار العميل' : 'اعتماد وإرسال الطلب للإدارة',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text('تجميد مؤقت', style: TextStyle(fontSize: 11, color: AppColors.danger)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/subscription_request_entity.dart';
import '../../finance/domain/usecases/get_subscriptions_usecase.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<SubscriptionRequestEntity> _subscriptions = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل 18';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetSubscriptionsUseCase>()();
    result.fold(
          (failure) => setState(() => _isLoading = false),
          (data) => setState(() {
        _subscriptions = data;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('طلبات الاشتراكات', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('برواح المازوري - الإدارة المالية', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Header Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, color: Colors.blueAccent, size: 14),
                        const SizedBox(width: 4),
                        Text('الرقابة المالية والتراخيص', style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('طلبات الاشتراكات والترقيات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark)),
                    const SizedBox(height: 2),
                    const Text('مراجعة وتفعيل اشتراكات المتاجر ومزودي الخدمات •\nبرواح المازوري', style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.3)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                      child: const Icon(Icons.search, color: Colors.black87, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                          child: const Icon(Icons.notifications_none, color: Colors.black87, size: 20),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Summary Dashboard Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Dark blue background
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('موجز دورة الاشتراكات الجارية', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('محدث الآن', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('رسوم الاشتراكات المعلقة', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('64,200', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1)),
                          const SizedBox(width: 4),
                          const Text('ر.س', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
                        child: Text('18 طلباً قيد التدقيق', style: TextStyle(color: Colors.red.shade900, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('المفعلة هذا الشهر', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  Icon(Icons.trending_up, color: Colors.lightBlueAccent, size: 14),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('142,500', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 2),
                                  Text('ر.س', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text('+24% نمو إيرادات', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('منتهية بانتظار التجديد', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  Icon(Icons.access_time, color: Colors.orangeAccent, size: 14),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('9', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Text('طلبات', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text('تنبيه تجاري آلي', style: TextStyle(color: Colors.orangeAccent, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل 18', isDark: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('المتاجر والتجار 8', icon: Icons.storefront),
                  const SizedBox(width: 8),
                  _buildFilterChip('مزودو الخدمات والمؤسسات 10', icon: Icons.handshake),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.primaryDark, size: 10),
                    SizedBox(width: 6),
                    Text('طلبات بانتظار المصادقة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.blueAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('ترتيب حسب الأحدث', style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. List
            ..._subscriptions.map((sub) => _buildSubscriptionCard(sub)),
            
            // 6. Bottom Info Banner
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.shield_outlined, color: Colors.blue.shade700, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('حوكمة اعتماد التراخيص والترقيات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(
                              'تفعيل الباقات يمنح فوراً الصلاحيات التجارية وأولوية الظهور والإعفاءات الرقابية المحددة في النظام المالي لشركة برواح المازوري. تخضع كافة العمليات للتدقيق المستندي والضريبي اللاحق.',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('سجل معتمد وموثق', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          _buildSmallButton('تقرير PDF', Icons.picture_as_pdf, Colors.red),
                          const SizedBox(width: 8),
                          _buildSmallButton('تصدير Excel', Icons.table_chart, Colors.green),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {IconData? icon, bool isDark = false}) {
    bool isSelected = _selectedFilter == label || isDark;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.blue.shade700),
            if (icon != null) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSmallButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(SubscriptionRequestEntity sub) {
    bool isAutoReady = sub.status.contains('جاهز');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  sub.type == SubscriptionType.merchant ? Icons.devices : Icons.build,
                  color: AppColors.primaryDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sub.providerName,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          sub.categoryName,
                          style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${sub.type == SubscriptionType.merchant ? 'س.ت:' : 'رخصة رقم:'} ${sub.registrationNumber}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAutoReady ? Colors.blue.shade50 : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAutoReady) const Icon(Icons.flash_on, color: AppColors.primaryDark, size: 12),
                    if (!isAutoReady) const Icon(Icons.circle, color: Colors.blueAccent, size: 8),
                    const SizedBox(width: 4),
                    Text(
                      sub.status,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAutoReady ? AppColors.primaryDark : Colors.blue.shade800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Amount & Package Box
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('نوع الباقة المستهدفة', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (sub.type == SubscriptionType.merchant) const Icon(Icons.stars, color: Colors.blue, size: 14),
                          if (sub.type == SubscriptionType.merchant) const SizedBox(width: 4),
                          Expanded(
                            child: Text(sub.targetPackageName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(sub.type == SubscriptionType.serviceProvider ? sub.durationText : '', style: TextStyle(fontSize: 10, color: Colors.blue.shade700)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    border: const Border(top: BorderSide(color: Color(0xFFEEEEEE)), bottom: BorderSide(color: Color(0xFFEEEEEE)), left: BorderSide(color: Color(0xFFEEEEEE))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(isAutoReady ? 'المبلغ المستحق' : 'المبلغ الإجمالي', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(CurrencyFormatter.format(sub.totalAmount), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(width: 2),
                          const Text('ر.س', style: TextStyle(fontSize: 10, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAutoReady ? 'رصيد كاف في المحفظة' : sub.durationText, // re-using durationText for "شامل الضريبة" in merchant case for mock purposes
                        style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Payment Method Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(isAutoReady ? Icons.account_balance_wallet : Icons.account_balance, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sub.paymentMethod,
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
                if (isAutoReady && sub.availableBalance != null)
                  Text(
                    sub.availableBalance!,
                    style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
                  ),
                if (!isAutoReady)
                  Text(
                    'حساب\nالشركات',
                    style: TextStyle(fontSize: 10, color: Colors.blue.shade700, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              if (isAutoReady)
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      backgroundColor: AppColors.dangerLight.withValues(alpha: 0.3),
                      side: const BorderSide(color: AppColors.dangerLight),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    onPressed: () {},
                    label: const Text('رفض مع السبب', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (isAutoReady) const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  onPressed: () {},
                  label: const Text('اعتماد و ارسال الطلب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          
          if (!isAutoReady) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  side: BorderSide(color: Colors.blue.shade100),
                  backgroundColor: Colors.blue.shade50.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.attachment, size: 16),
                onPressed: () {},
                label: const Text('معاينة الإيصال وبيانات التحويل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

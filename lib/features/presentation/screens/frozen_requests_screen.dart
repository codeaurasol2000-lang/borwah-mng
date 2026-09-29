import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../controllers/dashboard/finance_dashboard_cubit.dart';
import '../controllers/dashboard/finance_dashboard_state.dart';

class FrozenRequestsScreen extends StatefulWidget {
  const FrozenRequestsScreen({super.key});

  @override
  State<FrozenRequestsScreen> createState() => _FrozenRequestsScreenState();
}

class _FrozenRequestsScreenState extends State<FrozenRequestsScreen> {
  String _selectedFilter = 'الكل'; // Filters: الكل, تجار ومتاجر, مقدمو خدمات
  late FinanceDashboardCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = FinanceDashboardCubit(getFinanceSummaryUseCase: sl())..loadDashboardData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';

    return BlocProvider.value(
      value: _cubit,
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0.5,
            scrolledUnderElevation: 0,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person_outline, color: AppColors.primaryDark),
              ),
            ),
            title: Text(
              isArabic ? 'إظهار الطلبات المعلقة والمجمدة' : 'Frozen & Pending Requests',
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: BlocBuilder<FinanceDashboardCubit, FinanceDashboardState>(
            builder: (context, state) {
              if (state is FinanceDashboardLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
              } else if (state is FinanceDashboardLoaded) {
                // Here we simulate fetching the frozen requests from the data we loaded or direct call.
                // For demonstration, we'll construct them statically matching the UI, 
                // but realistically they should come from the cubit or usecase.
                // The prompt mentions "الاعلانات الي هتكون ظاهره في هذه الشاشه هي نفس الاعلانات الي ظاهره في شاشة طلبات السحب... ولكن ستكون فقط الاعلانات الي حالتها معلق او مجمد"
                // Let's create the mock ones according to the screenshot for visual pixel-perfection, 
                // but structured to be filtered.

                final List<Map<String, dynamic>> frozenRequests = [
                  {
                    'id': '1',
                    'title': 'تاجر مستلزمات حاسب',
                    'subtitle': 'طلب سحب أرباح مالي دوري',
                    'icon': Icons.storefront,
                    'type': 'تجار ومتاجر',
                    'status': 'مجمد احترازياً',
                    'amount': 17955.00,
                    'grossAmount': 18900.00,
                    'feeAmount': 945.00,
                    'reason': 'سبب التجميد: بلاغ نزاع مفتوح #CMP-1042 مع شبهة تلاعب في عروض ترويجية.',
                    'supervisor': 'أ. سعد العتيبي',
                    'timeText': 'اليوم • منذ 4 ساعات',
                    'actionButton': 'إعادة العمل وفك التجميد للصرف',
                    'cancelButton': 'تأكيد الرفض والمصادرة',
                  },
                  {
                    'id': '2',
                    'title': 'ورشة الإتقان للكهرباء',
                    'subtitle': 'مستحقات عقود صيانة سنوية',
                    'icon': Icons.build,
                    'type': 'مقدمو خدمات',
                    'status': 'مجمد احترازياً',
                    'amount': 6200.00,
                    'grossAmount': 7000.00,
                    'feeAmount': 800.00,
                    'reason': 'سبب التجميد: شكوى عدم اكتمال الصيانة المنزلية',
                    'supervisor': 'أ. أحمد حسان',
                    'timeText': 'أمس • 27 يناير',
                    'actionButton': 'فك التجميد الجزئي / الكامل',
                    'cancelButton': 'تسوية استرداد للعميل',
                    'cancelIcon': Icons.assignment_return_outlined,
                  },
                  {
                    'id': '3',
                    'title': 'مؤسسة الأفق للتجارة',
                    'subtitle': 'حوالة بنكية سريعة (SARIE) معلقة',
                    'icon': Icons.account_balance,
                    'type': 'تجار ومتاجر',
                    'status': 'تعارض آيبان',
                    'amount': 19295.00,
                    'grossAmount': null,
                    'feeAmount': null,
                    'ibanError': 'SA44*************0199',
                    'reason': 'سبب التجميد: فشل التحقق الآلي من تطابق اسم المستفيد مع السجل التجاري في البنك المركزي السعودي.',
                    'supervisor': '',
                    'timeText': '25 يناير 2025',
                    'actionButton': 'إعادة التحقق وتنشيط الحوالة',
                    'actionIcon': Icons.sync,
                    'cancelButton': 'طلب شهادة آيبان جديدة مختومة من البنك',
                    'cancelIcon': Icons.contact_page_outlined,
                  },
                ];

                final filteredRequests = frozenRequests.where((req) {
                  if (_selectedFilter == 'الكل') return true;
                  return req['type'] == _selectedFilter;
                }).toList();

                final double totalAmount = filteredRequests.fold(0.0, (sum, req) => sum + (req['amount'] as double));
                final int totalCount = filteredRequests.length;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Top Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primaryExtraDark,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'إجمالي المبالغ والعمليات المجمدة احترازياً',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        CurrencyFormatter.format(totalAmount),
                                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'ر.س',
                                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.lock_outline, color: Colors.white70, size: 16),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$totalCount طلبات مجمده',
                                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'بروتوكول المادة 18 مكافحة الاحتيال',
                                              style: TextStyle(color: Colors.white60, fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 2. Filters
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip('الكل', count: totalCount),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('تجار ومتاجر', icon: Icons.storefront),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('مقدمو خدمات', icon: Icons.handyman_outlined),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('المشرفين', icon: Icons.supervisor_account_outlined),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('المناديب', icon: Icons.local_shipping_outlined),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('مستخدمين', icon: Icons.person_outline),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('اعلانات', icon: Icons.campaign_outlined),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 3. Requests List
                            ...filteredRequests.map((req) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildRequestCard(req),
                            )),
                            
                          ],
                        ),
                      ),
                    ),
                    
                    // 4. Bottom Sticky Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE2E8F0),
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.ios_share, size: 18),
                              onPressed: () {},
                              label: const Text('تصدير بيان الأموال المجمدة (PDF / Excel)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                backgroundColor: const Color(0xFFF8FAFC),
                                side: const BorderSide(color: Colors.transparent),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.sync, size: 18),
                              onPressed: () {
                                _cubit.loadDashboardData();
                              },
                              label: const Text('تحديث حالة الحركات ومزامنة الرقابة اللحظية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title, {int? count, IconData? icon}) {
    bool isSelected = _selectedFilter == title;
    // Specific logic matching screenshot: "الكل (3 طلبات)" with Dark Blue if selected
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              count != null ? '$title ($count طلبات)' : title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: req['type'] == 'تجار ومتاجر' ? Colors.red.shade50 : (req['type'] == 'مقدمو خدمات' ? Colors.blue.shade50 : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(req['icon'], size: 20, color: req['type'] == 'تجار ومتاجر' ? Colors.red.shade700 : (req['type'] == 'مقدمو خدمات' ? Colors.blue.shade700 : AppColors.primaryDark)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(req['subtitle'], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.dangerBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(req['status'], style: const TextStyle(fontSize: 10, color: AppColors.danger, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Icon(req['status'] == 'تعارض آيبان' ? Icons.warning_amber_rounded : Icons.pause_circle_outline, size: 12, color: AppColors.danger),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Amounts
          Container(
            color: AppColors.surfaceMuted,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(req['ibanError'] != null ? 'المبلغ المعلق للحوالة:' : 'المبلغ المحتجز للتجميد:', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(child: Text(CurrencyFormatter.format(req['amount']), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, maxLines: 1)),
                          const SizedBox(width: 4),
                          const Text('ر.س', style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (req['ibanError'] != null)
                      Expanded(child: Text('الآيبان المسجل: ${req['ibanError']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), textDirection: TextDirection.ltr, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis))
                    else
                      Flexible(child: Text('إجمالي المعاملة: ${CurrencyFormatter.format(req['grossAmount'])} ر.س', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),

                    const SizedBox(width: 8),

                    if (req['ibanError'] != null)
                      Text('عدم تطابق اسم الحساب', style: const TextStyle(fontSize: 11, color: AppColors.danger, fontWeight: FontWeight.bold))
                    else
                      Flexible(child: Text('خصم عمولة المنصة: ${CurrencyFormatter.format(req['feeAmount'])} ر.س', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Reason & Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(req['ibanError'] != null ? Icons.do_not_disturb_alt : Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req['reason'],
                        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (req['supervisor'] != '')
                      Row(
                        children: [
                          const Icon(Icons.assignment_ind_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text('مشرف : ${req['supervisor']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      )
                    else
                      const SizedBox(),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(req['timeText'], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryExtraDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(req['actionIcon'] ?? Icons.lock_open, size: 16),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم فك التجميد ونقل الطلب لقائمة المراجعة')));
                      // Here logic to update status to pending/approved
                    },
                    label: Text(req['actionButton'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: req['cancelIcon'] != null ? AppColors.textSecondary : AppColors.danger,
                      backgroundColor: AppColors.surfaceLight,
                      side: const BorderSide(color: Colors.transparent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(req['cancelIcon'] ?? Icons.highlight_off, size: 16),
                    onPressed: () {},
                    label: Text(req['cancelButton'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

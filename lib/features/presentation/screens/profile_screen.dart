import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/withdraw_bottom_sheet.dart';
import 'edit_matrix_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          toolbarHeight: 48,
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, size: 14, color: AppColors.info),
                  SizedBox(width: 4),
                  Text(
                    'CFO',
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ملفك الشخصي',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Text(
                'الإدارة المالية',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryExtraDark,
                child: Icon(Icons.person_outline, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Security Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          const Text('مشفر bit-256', style: TextStyle(fontSize: 10, color: AppColors.textSecondary), textDirection: TextDirection.ltr),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'جلسة رقابية آمنة ومصادق عليها',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.verified_user_outlined, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 1. Profile Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryExtraDark,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('#CFO-01', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
                                    ),
                                    const SizedBox(width: 8),
                                    const Flexible(child: Text('أ. سليمان الراجحي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text('المدير المالي التنفيذي ورئيس الرقابة المحاسبية', style: TextStyle(fontSize: 11, color: AppColors.info)),
                                const SizedBox(height: 4),
                                const Text('CFO & Head of Financial Auditing', style: TextStyle(fontSize: 10, color: AppColors.textSecondary), textDirection: TextDirection.ltr),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Upload profile image action
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Icon(Icons.account_circle, size: 60, color: Colors.grey),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryExtraDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: Text('صلاحيات الاعتماد السيادي والمصادقة البنكية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.right)),
                              const SizedBox(width: 8),
                              Icon(Icons.account_balance, size: 16, color: Colors.blue.shade700),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text('مدقق مالي معتمد • مفوض التوقيع والمصادقة البنكية\nالمزدوجة لدى مؤسسة برواح المازوري', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildContactBox('الهاتف المعتمد', '+201014189187', Icons.phone_android, false),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildContactBox('البريد المؤسسي', 's.alrajhi@almazouri.sa', Icons.email_outlined, true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fingerprint, color: AppColors.info, size: 16),
                              const SizedBox(width: 4),
                              Text('نفاذ وطني مفعل', style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text('سريان الاعتماد الرقابي من: 2027م', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Wallet Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryExtraDark.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.circle, size: 6, color: Colors.white),
                                const SizedBox(width: 4),
                                const Text('نشط ومطابق', style: TextStyle(color: Colors.white, fontSize: 10)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('محفظة المستحقات\nوالأتعاب', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.2), textAlign: TextAlign.right),
                              const SizedBox(height: 4),
                              const Text('حساب الإدارة والرقابة التنفيذية المباشر', style: TextStyle(color: Colors.white60, fontSize: 10)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('إجمالي رصيد المستحقات المحاسبية', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('68,500.00', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1)),
                        SizedBox(width: 4),
                        Text('ر.س', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text('رصيد معلق رقابيا', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                      const SizedBox(width: 4),
                                      Icon(Icons.circle, size: 6, color: Colors.blueGrey.shade400),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('16,500.00', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 2),
                                      Text('ر.س', style: TextStyle(color: Colors.white70, fontSize: 9)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('بانتظار الإقفال الربع سنوي', style: TextStyle(color: Colors.white54, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text('جاهز للصرف الفوري', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                      const SizedBox(width: 4),
                                      Icon(Icons.circle, size: 6, color: Colors.blue.shade200),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('52,000.00', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 2),
                                      Text('ر.س', style: TextStyle(color: Colors.white70, fontSize: 9)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('معتمد دون شروط', style: TextStyle(color: Colors.white54, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 20),
                          const Spacer(),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('الحساب المصفي المعتمد للصرف', style: TextStyle(color: Colors.white60, fontSize: 9)),
                              Text('SA44 8000 0001 **** 3456', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2), textDirection: TextDirection.ltr),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('RAJHI', style: TextStyle(color: AppColors.primaryExtraDark, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.arrow_circle_left_outlined, size: 18),
                              onPressed: () {
                                showWithdrawBottomSheet(context);
                              },
                              label: const Text('طلب سحب الارباح من المالك', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.arrow_circle_left_outlined, size: 18),
                              onPressed: () {},
                              label: const Text('تعديل معلومات السحب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Section Title
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('مقتصرة على CFO', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  Row(
                    children: [
                      Text('التحكم والإجراءات السيادية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      SizedBox(width: 8),
                      Icon(Icons.tune, color: AppColors.primaryDark, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Matrix Settings
              _buildSettingCard(
                title: 'مصفوفة الرسوم\nوالعمولات العامة',
                subtitle: 'ضبط النسب المئوية للمنصة، اقتطاعات بوابات الدفع الإلكترونية، وتعديل تسعير العمليات التعاقدية.',
                icon: Icons.account_tree_outlined,
                badgeText: 'صلاحية حصرية',
                content: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryExtraDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditMatrixScreen()),
                          );
                        },
                        label: const Text('تعديل\nالمصفوفة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.2), textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('رسوم التسوية\nالسريعة', style: TextStyle(fontSize: 9, color: AppColors.textSecondary, height: 1.2), textAlign: TextAlign.right),
                          const SizedBox(height: 4),
                          Text('1.25%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: AppColors.cardBorder, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('العمولة الأساسية\nالحالية', style: TextStyle(fontSize: 9, color: AppColors.textSecondary, height: 1.2), textAlign: TextAlign.right),
                          const SizedBox(height: 4),
                          const Text('4.50%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 5. Reports Card
              _buildSettingCard(
                title: 'كشف المدفوعات\nوالإيرادات الشامل',
                subtitle: 'توليد كشوف التدفقات النقدية، تقارير الضريبة العامة المضافة، وحزم التسويات المصرفية المجمعة.',
                icon: Icons.bar_chart_outlined,
                content: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.grid_on_outlined, size: 16),
                        onPressed: () {},
                        label: const Text('تصدير Excel تفصيلي', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                        onPressed: () {},
                        label: const Text('تصدير PDF معتمد', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 6. Timeline Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('مباشر • موثق', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                  ),
                  const Row(
                    children: [
                      Text('سجل الرقابة وحركات المدير المالي', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      SizedBox(width: 8),
                      Icon(Icons.history, color: AppColors.primaryDark, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7. Timeline List
              _buildTimelineItem(
                title: 'مصادقة صرف تسوية نزاع مالك',
                time: 'اليوم 11:00 ص',
                description: 'اعتماد صرف تسوية النزاع #CMP-1035 بقيمة\n1,200.00 ر.س للعميل د. طارق العمري.',
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.primaryDark,
                bgColor: Colors.blue.shade50,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('المرجع: #SIG-9082', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Text('توقيع رقمي ساري SHA-256', style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.key, size: 10, color: Colors.blue.shade700),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                title: 'اعتماد سحب أرباح مجمعة (SARIE)',
                time: 'اليوم 09:30 ص',
                description: 'تحويل مستحقات دورية لـ 12 متجر معتمد عبر نظام\nالمدفوعات الفورية بإجمالي 142,500.00 ر.س.',
                icon: Icons.payments_outlined,
                iconColor: AppColors.textPrimary,
                bgColor: AppColors.surfaceLight,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('مصرف الراجحي', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: const Row(
                        children: [
                          Text('منفذة بنكيا ومقيدة', style: TextStyle(fontSize: 9, color: AppColors.textPrimary)),
                          SizedBox(width: 4),
                          Icon(Icons.check_circle_outline, size: 10, color: AppColors.success),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                title: 'تجميد احترازي لمحفظة متجر',
                time: 'أمس 04:15 م',
                description: 'إيقاف عمليات الصرف لمتجر مستلزمات حاسب (#TRD-304) لوجود شبهة نزاع مدفوعات متكرر.',
                icon: Icons.lock_outline,
                iconColor: AppColors.danger,
                bgColor: AppColors.dangerLight,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('إشعار التدقيق #771', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.dangerLight, border: Border.all(color: AppColors.dangerBorder), borderRadius: BorderRadius.circular(4)),
                      child: const Row(
                        children: [
                          Text('قيد التحقيق والتدقيق', style: TextStyle(fontSize: 9, color: AppColors.danger, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.gavel, size: 10, color: AppColors.danger),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimelineItem(
                title: 'تحديث عمولة قطاع الصيانة',
                time: 'أمس 01:20 م',
                description: 'تعديل نسبة العمولة المحصلة إلى 8.0% بموجب قرار\nمجلس الإدارة رقم BOD-44/B.',
                icon: Icons.percent,
                iconColor: Colors.blue.shade700,
                bgColor: Colors.blue.shade50,
                isLast: true,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(4)),
                      child: const Row(
                        children: [
                          Text('تحديث نظامي نافذ', style: TextStyle(fontSize: 9, color: AppColors.textPrimary)),
                          SizedBox(width: 4),
                          Icon(Icons.check_box_outlined, size: 10, color: AppColors.textPrimary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBorder,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  onPressed: () {},
                  label: const Text('عرض سجل الرقابة والحركات الكامل (342 حركة موثقة)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactBox(String title, String value, IconData icon, bool obscure) {
    return _ObscureContactBox(title: title, value: value, icon: icon, obscureInit: obscure);
  }

  Widget _buildSettingCard({required String title, required String subtitle, required IconData icon, String? badgeText, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text(badgeText, style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.right),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.right),
              ),
              const SizedBox(width: 44), // To align with the text above
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    Widget? bottomWidget,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                      Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.4), textAlign: TextAlign.right),
                  if (bottomWidget != null) ...[
                    const SizedBox(height: 8),
                    bottomWidget,
                  ],
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: AppColors.cardBorder,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
class _ObscureContactBox extends StatefulWidget { final String title; final String value; final IconData icon; final bool obscureInit; const _ObscureContactBox({required this.title, required this.value, required this.icon, required this.obscureInit}); @override State<_ObscureContactBox> createState() => _ObscureContactBoxState(); } class _ObscureContactBoxState extends State<_ObscureContactBox> { late bool _isObscured; @override void initState() { super.initState(); _isObscured = widget.obscureInit; } @override Widget build(BuildContext context) { String displayValue = widget.value; if (_isObscured && widget.value.contains('@')) { final parts = widget.value.split('@'); if (parts[0].length > 2) { displayValue = '${parts[0].substring(0, 2)}***@${parts[1]}'; } else { displayValue = '***@${parts[1]}'; } } return GestureDetector( onTap: () { if (widget.obscureInit) { setState(() { _isObscured = !_isObscured; }); } }, child: Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration( color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10), ), child: Row( mainAxisAlignment: MainAxisAlignment.end, children: [ Expanded( child: Column( crossAxisAlignment: CrossAxisAlignment.end, children: [ Text(widget.title, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)), const SizedBox(height: 2), FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text( displayValue, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textDirection: TextDirection.ltr, ), ), ], ), ), const SizedBox(width: 8), Icon(widget.icon, size: 18, color: AppColors.textPrimary), ], ), ), ); } }

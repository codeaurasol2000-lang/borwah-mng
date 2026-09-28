import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EditMatrixScreen extends StatefulWidget {
  const EditMatrixScreen({super.key});

  @override
  State<EditMatrixScreen> createState() => _EditMatrixScreenState();
}

class _EditMatrixScreenState extends State<EditMatrixScreen> {
  final TextEditingController _reasonController = TextEditingController(
    text: 'تعديل دوري لمواكبة تحديثات رسوم بوابات الدفع البنكية وتوسعة شبكة التوصيل الميداني',
  );
  bool _addFixedFee = true;
  bool _notifyAll = true;
  String _deliveryCommissionType = 'percentage'; // 'percentage' or 'fixed'

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.person_outline, color: AppColors.primaryDark),
            ),
          ),
          title: const Text(
            'تعديل مصفوفة نسب الأرباح والر...',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textPrimary, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                            const SizedBox(width: 4),
                            const Text('مباشر', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text('صلاحية سيادية حصرية للمدير المالي (CFO-01)', style: TextStyle(color: Colors.white, fontSize: 9)),
                              SizedBox(width: 6),
                              Icon(Icons.verified_user_outlined, color: Colors.white, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تحديد النسب الرسمية لاقتطاعات المنصة التلقائية وتحديث محرك التسويات والرسوم اللوجستية لكافة العمليات المالية المعتمدة.',
                      style: TextStyle(color: Colors.white, fontSize: 11, height: 1.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'آخر تحديث: 01 يناير 2025 بموجب قرار مجلس الإدارة رقم BOD-44/B',
                      style: TextStyle(color: Colors.white60, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 1: General Sales Percentage
              _buildCard(
                icon: Icons.storefront_outlined,
                title: 'النسبة العامة للمبيعات والمتاجر',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(6)),
                          child: const Text('النطاق: 10.0% - 2.0%', style: TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
                        ),
                        const Text('النسبة المطبقة حالياً', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('4.50%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: const Row(
                                  children: [
                                    Text('%', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 12),
                                    Text('4.50', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  ],
                                ),
                              ),
                              const Text('ضبط النسبة المستهدفة', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الحد الأدنى 2.0%', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                              Text('المرجعي 5.0%', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                              Text('الحد الأقصى 10.0%', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: AppColors.info),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'تُطبق على جميع صفقات المتاجر، المنتجات الجديدة، ومبيعات الأجهزة المباشرة دون استثناءات محلية.',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Wallet Settlement
              _buildCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'رسوم تسوية المحافظ والاسترداد',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(6)),
                          child: const Text('1.25 %', style: TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
                        ),
                        const Text('رسم التسوية الحالية', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('1.25%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoSwitch(
                            value: _addFixedFee,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) {
                              setState(() {
                                _addFixedFee = val;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('رسم ثابت إضافي (تسوية فورية)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text('تطبيق رسم مقطوع بقيمة 5.00 ر.س لكل تسوية مستعجلة', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('تفصيل التغطية التكلفة:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                              const SizedBox(width: 4),
                              Icon(Icons.pie_chart_outline, size: 14, color: Colors.blue.shade700),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('تغطية مصاريف بوابات الدفع (Mada / Visa / SARIE) بنسبة 0.85%', style: TextStyle(fontSize: 9, color: AppColors.textPrimary), textDirection: TextDirection.rtl),
                          const SizedBox(height: 2),
                          const Text('+ هامش تشغيلي وقائي بنسبة 0.40%', style: TextStyle(fontSize: 9, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تُقتطع تلقائياً عند طلب التسوية السريعة عبر شبكة المدفوعات اللوجستية الفورية واسترداد النزاعات.',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.4),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: Delivery Commission
              _buildCard(
                icon: Icons.local_shipping_outlined,
                title: 'عمولة قطاع التوصيل والنقل والشحن',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                          child: Text('أسطول وصلني & الشركاء', style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                        ),
                        const Text('العمولة المعتمدة حالياً', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('7.00%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),
                    
                    // Options
                    GestureDetector(
                      onTap: () => setState(() => _deliveryCommissionType = 'percentage'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _deliveryCommissionType == 'percentage' ? AppColors.surfaceMuted : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _deliveryCommissionType == 'percentage' ? AppColors.cardBorder : Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300)),
                              child: const Text('7.00%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: [
                                const Text('نسبة مئوية من قيمة التوصيل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                const SizedBox(width: 8),
                                Icon(_deliveryCommissionType == 'percentage' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _deliveryCommissionType == 'percentage' ? AppColors.primaryDark : Colors.grey, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _deliveryCommissionType = 'fixed'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _deliveryCommissionType == 'fixed' ? AppColors.surfaceMuted : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _deliveryCommissionType == 'fixed' ? AppColors.cardBorder : Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300)),
                              child: const Text('3.00 ر.س', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ),
                            Row(
                              children: [
                                const Text('مبلغ مقطوع ثابت لكل شحنة', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(width: 8),
                                Icon(_deliveryCommissionType == 'fixed' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _deliveryCommissionType == 'fixed' ? AppColors.primaryDark : Colors.grey, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 14, color: AppColors.info),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'تُحتسب على كل عملية توصيل ناجحة لمناديب أسطول وصلني والشركات اللوجستية المتعاقدة وتُودع بالمحفظة المركزية.',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 4: Audit Reason
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('المسوغ المحاسبي والإلزامي للرقابة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(width: 8),
                        Icon(Icons.gavel, color: AppColors.danger, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('سبب وموجب تعديل النسب (إلزامي للرقابة والتدقيق المركزي):', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _reasonController,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _notifyAll = !_notifyAll),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'إشعار فوري لجميع التجار والمناديب والمشرفين بتحديث قائمة الأسعار قبل 7 أيام من موعد التطبيق الإلزامي.',
                              style: TextStyle(fontSize: 10, color: AppColors.textPrimary, height: 1.4),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: _notifyAll ? AppColors.primaryExtraDark : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.primaryExtraDark),
                            ),
                            child: _notifyAll ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: AppColors.surfaceLight,
                        side: const BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryExtraDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.drive_file_rename_outline, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع التعديلات للسجل المالي بنجاح')));
                        Navigator.pop(context);
                      },
                      label: const Text('حفظ وإرسال مصفوفة النسب رسمياً للإدارة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('سيتم قيد هذا الإجراء تلقائياً في سجل التدقيق المالي المركزي SHA-256', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                  SizedBox(width: 6),
                  Icon(Icons.lock_outline, size: 12, color: AppColors.textSecondary),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

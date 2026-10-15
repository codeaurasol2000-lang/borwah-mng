class ProductSupervisorAuditEntry {
  final String id;
  final String actionKey;
  final String subject;
  final String details;
  final String actorName;
  final DateTime occurredAt;

  const ProductSupervisorAuditEntry({
    required this.id,
    required this.actionKey,
    required this.subject,
    required this.details,
    this.actorName = 'مشرف المنتجات',
    required this.occurredAt,
  });
}

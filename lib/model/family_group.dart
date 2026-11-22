class FamilyGroup {
  final String id;
  final String administratorUuid;
  final String currency;
  final String? name;
  final String? inviteToken;
  final bool active;
  final DateTime createdAt;

  FamilyGroup({
    required this.id,
    required this.administratorUuid,
    required this.currency,
    this.name,
    this.inviteToken,
    this.active = true,
    required this.createdAt,
  });
}

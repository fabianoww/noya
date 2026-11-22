class FamilyMember {
  final String uuid;
  String name;
  String? firebaseUid;
  String? publicKey;
  String? signingPublicKey;
  String role;
  DateTime? joinedAt;
  DateTime? leftAt;
  bool active;

  FamilyMember({
    required this.uuid,
    required this.name,
    this.firebaseUid,
    this.publicKey,
    this.signingPublicKey,
    this.role = 'member',
    this.joinedAt,
    this.leftAt,
    this.active = true,
  });

  bool get isAdministrator => role == 'administrator';
}

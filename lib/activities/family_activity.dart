import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/family_action_result.dart';
import 'package:noya2/model/family_member.dart';
import 'package:noya2/services/configuration_service.dart';
import 'package:noya2/services/family_service.dart';

class FamilyActivity extends StatefulWidget {
  const FamilyActivity({super.key});

  @override
  State<FamilyActivity> createState() => _FamilyActivityState();
}

class _FamilyActivityState extends State<FamilyActivity> {
  final _nameController = TextEditingController();
  final _currencyController = TextEditingController(text: 'BRL');
  final _memberNameController = TextEditingController();
  final _memberUuidController = TextEditingController();
  bool _defaultPrivate = false;
  bool _loading = true;
  bool _hasGroup = false;
  String? _ownMemberUuid;
  List<FamilyMember> _members = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final group = await FamilyService.getActiveGroup();
    final members = await FamilyService.listMembers();
    final ownMemberUuid = await FamilyService.getOwnMemberUuid();
    final defaultPrivate = await ConfigurationService.familyDefaultPrivate();
    if (!mounted) return;
    setState(() {
      _hasGroup = group != null;
      _members = members;
      _ownMemberUuid = ownMemberUuid;
      _defaultPrivate = defaultPrivate;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _memberNameController.dispose();
    _memberUuidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.family_mode)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(l10n.family_default_private_title),
            subtitle: Text(l10n.family_default_private_subtitle),
            value: _defaultPrivate,
            onChanged: (value) async {
              await ConfigurationService.saveFamilyDefaultPrivate(value);
              setState(() => _defaultPrivate = value);
            },
          ),
          const Divider(),
          if (!_hasGroup) ...[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.family_your_name,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _currencyController,
              decoration: InputDecoration(
                labelText: l10n.family_currency,
                prefixIcon: const Icon(Icons.attach_money),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) return;
                await FamilyService.createGroup(
                  administratorName: _nameController.text.trim(),
                  currency: _currencyController.text.trim().toUpperCase(),
                );
                await _load();
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.family_create_group),
            ),
          ] else ...[
            Text(
              l10n.family_members,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final member in _members)
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(member.name),
                subtitle: Text(
                  member.isAdministrator
                      ? l10n.family_role_administrator
                      : l10n.family_role_member,
                ),
                trailing:
                    member.isAdministrator ||
                        !_members.any(
                          (candidate) =>
                              candidate.uuid == _ownMemberUuid &&
                              candidate.isAdministrator,
                        )
                    ? null
                    : TextButton(
                        onPressed: () => _transferAdministration(member.uuid),
                        child: Text(l10n.family_transfer_administration),
                      ),
              ),
            const Divider(),
            TextField(
              controller: _memberNameController,
              decoration: InputDecoration(
                labelText: l10n.family_new_member_name,
                prefixIcon: const Icon(Icons.person_add),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _memberUuidController,
              decoration: InputDecoration(
                labelText: l10n.family_new_member_uuid,
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                if (_memberNameController.text.trim().isEmpty ||
                    _memberUuidController.text.trim().isEmpty) {
                  return;
                }
                await FamilyService.addApprovedMember(
                  memberUuid: _memberUuidController.text.trim(),
                  name: _memberNameController.text.trim(),
                );
                await _load();
              },
              icon: const Icon(Icons.how_to_reg),
              label: Text(l10n.family_approve_member),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _leaveGroup,
              icon: const Icon(Icons.logout),
              label: Text(l10n.family_leave_group),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _transferAdministration(String newAdministratorUuid) async {
    final l10n = AppLocalizations.of(context)!;
    final currentAdministratorUuid = _ownMemberUuid;
    if (currentAdministratorUuid == null) {
      await _showMessage(
        l10n.family_leave_admin_requires_transfer_title,
        l10n.family_transfer_admin_not_allowed,
      );
      return;
    }

    final result = await FamilyService.transferAdministration(
      currentAdministratorUuid,
      newAdministratorUuid,
    );
    if (!mounted) return;
    if (result == FamilyAdministrationResult.transferred) {
      await _load();
    } else {
      await _showMessage(
        l10n.family_leave_admin_requires_transfer_title,
        l10n.family_transfer_admin_not_allowed,
      );
    }
  }

  Future<void> _leaveGroup() async {
    final l10n = AppLocalizations.of(context)!;
    final ownUuid = _ownMemberUuid;
    if (ownUuid == null) {
      await _showMessage(
        l10n.family_leave_admin_requires_transfer_title,
        l10n.family_leave_member_not_active,
      );
      return;
    }

    final members = await FamilyService.listMembers();
    if (!mounted) return;
    final ownMembers = members.where((member) => member.uuid == ownUuid);
    if (ownMembers.isEmpty) {
      await _showMessage(
        l10n.family_leave_admin_requires_transfer_title,
        l10n.family_leave_member_not_active,
      );
      return;
    }

    final isAdministrator = ownMembers.first.isAdministrator;
    if (isAdministrator && members.length > 1) {
      await _showMessage(
        l10n.family_leave_admin_requires_transfer_title,
        l10n.family_leave_admin_requires_transfer_message,
      );
      return;
    }

    var deleteOtherMembersHistory = false;
    if (isAdministrator) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.family_leave_admin_last_title),
          content: Text(l10n.family_leave_admin_last_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.family_leave_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.button_yes),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    } else {
      final deleteHistory = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.family_leave_member_title),
          content: Text(l10n.family_leave_member_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.family_leave_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.family_leave_keep_history),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.family_leave_delete_history),
            ),
          ],
        ),
      );
      if (deleteHistory == null) return;
      deleteOtherMembersHistory = deleteHistory;
    }

    final result = await FamilyService.leave(
      ownUuid,
      deleteOtherMembersHistory: deleteOtherMembersHistory,
    );
    if (!mounted) return;

    switch (result) {
      case FamilyLeaveResult.left:
        await _load();
        break;
      case FamilyLeaveResult.administratorMustTransfer:
        await _showMessage(
          l10n.family_leave_admin_requires_transfer_title,
          l10n.family_leave_admin_requires_transfer_message,
        );
        break;
      case FamilyLeaveResult.memberNotActive:
        await _showMessage(
          l10n.family_leave_admin_requires_transfer_title,
          l10n.family_leave_member_not_active,
        );
        break;
    }
  }

  Future<void> _showMessage(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.error_close),
          ),
        ],
      ),
    );
  }
}

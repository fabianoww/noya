import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/family_cloud_service.dart';
import 'package:noya2/services/firebase_emulator_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FamilyCloudPanel extends StatefulWidget {
  const FamilyCloudPanel({super.key});

  @override
  State<FamilyCloudPanel> createState() => _FamilyCloudPanelState();
}

class _FamilyCloudPanelState extends State<FamilyCloudPanel> {
  final _nameController = TextEditingController();
  final _currencyController = TextEditingController(text: 'BRL');
  Map<String, dynamic>? _familyState;
  List<Map<String, dynamic>> _requests = [];
  String? _invitePayload;
  DateTime? _inviteExpiry;
  String? _error;
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseEmulatorService.isEnabled) {
      _refresh();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!FirebaseEmulatorService.enabled) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.cloud_off),
          title: Text(l10n.family_cloud_title),
          subtitle: Text(l10n.family_cloud_emulator_disabled),
        ),
      );
    }
    if (!_initialized && _loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.family_cloud_title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(l10n.family_cloud_no_financial_sync),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_familyState == null)
              _buildUnavailable(l10n)
            else
              _buildFamilyContent(l10n),
            if (_loading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailable(AppLocalizations l10n) {
    if (_error != null) {
      return TextButton.icon(
        onPressed: _refresh,
        icon: const Icon(Icons.refresh),
        label: Text(l10n.family_cloud_retry),
      );
    }
    return Text(l10n.family_cloud_connecting);
  }

  Widget _buildFamilyContent(AppLocalizations l10n) {
    final state = _familyState!;
    switch (state['status']) {
      case 'none':
        return _buildCreateOrJoin(l10n);
      case 'pending':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l10n.family_cloud_pending),
            ),
            TextButton.icon(
              onPressed: _loading ? null : _refresh,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.family_cloud_refresh),
            ),
          ],
        );
      case 'approved':
        return _buildApproved(l10n, state);
      default:
        return Text(l10n.family_cloud_invalid_response);
    }
  }

  Widget _buildCreateOrJoin(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: l10n.family_your_name),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _currencyController,
          decoration: InputDecoration(labelText: l10n.family_currency),
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _loading ? null : () => _createGroup(l10n),
          icon: const Icon(Icons.group_add),
          label: Text(l10n.family_cloud_create_group),
        ),
        OutlinedButton.icon(
          onPressed: _loading ? null : () => _scanInvite(l10n),
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l10n.family_cloud_scan_invite),
        ),
      ],
    );
  }

  Widget _buildApproved(AppLocalizations l10n, Map<String, dynamic> state) {
    final isAdministrator = state['role'] == 'administrator';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.family_cloud_member_status(
            state['name'] as String? ?? '',
            state['role'] == 'administrator'
                ? l10n.family_role_administrator
                : l10n.family_role_member,
          ),
        ),
        if (isAdministrator) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _loading ? null : _createInvite,
            icon: const Icon(Icons.qr_code_2),
            label: Text(l10n.family_cloud_generate_invite),
          ),
          if (_invitePayload != null) ...[
            const SizedBox(height: 8),
            Center(
              child: QrImageView(
                data: _invitePayload!,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),
            if (_inviteExpiry != null)
              Text(
                l10n.family_cloud_invite_expires(
                  '${MaterialLocalizations.of(context).formatMediumDate(_inviteExpiry!.toLocal())} '
                  '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(_inviteExpiry!.toLocal()))}',
                ),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.family_cloud_join_requests,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (_requests.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(l10n.family_cloud_no_join_requests),
            ),
          for (final request in _requests)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(request['name'] as String? ?? ''),
              subtitle: Text(l10n.family_cloud_request_pending),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    tooltip: l10n.family_cloud_approve,
                    onPressed: _loading
                        ? null
                        : () => _resolveRequest(
                            request['requestId'] as String,
                            true,
                          ),
                    icon: const Icon(Icons.check),
                  ),
                  IconButton(
                    tooltip: l10n.family_cloud_reject,
                    onPressed: _loading
                        ? null
                        : () => _resolveRequest(
                            request['requestId'] as String,
                            false,
                          ),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _loading ? null : _refresh,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.family_cloud_refresh),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FamilyCloudService.ensureSignedIn();
      final state = await FamilyCloudService.getState();
      List<Map<String, dynamic>> requests = [];
      if (state['status'] == 'approved' && state['role'] == 'administrator') {
        requests = await FamilyCloudService.listJoinRequests(
          state['groupId'] as String,
        );
      }
      if (!mounted) return;
      setState(() {
        _familyState = state;
        _requests = requests;
        _initialized = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _initialized = true;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createGroup(AppLocalizations l10n) async {
    final name = _nameController.text.trim();
    final currency = _currencyController.text.trim().toUpperCase();
    if (name.isEmpty || currency.length != 3) {
      setState(() => _error = l10n.family_cloud_invalid_group);
      return;
    }
    await _run(() async {
      await FamilyCloudService.createGroup(name: name, currency: currency);
      await _refresh();
    });
  }

  Future<void> _createInvite() async {
    final groupId = _familyState?['groupId'] as String?;
    if (groupId == null) return;
    await _run(() async {
      final invite = await FamilyCloudService.createInvite(groupId);
      final token = invite['token'] as String;
      final expiry = DateTime.parse(invite['expiresAt'] as String);
      if (!mounted) return;
      setState(() {
        _invitePayload =
            'noya://family/join?token=${Uri.encodeQueryComponent(token)}';
        _inviteExpiry = expiry;
      });
    });
  }

  Future<void> _scanInvite(AppLocalizations l10n) async {
    final token = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) =>
            _FamilyInviteScanner(title: l10n.family_cloud_scan_invite),
      ),
    );
    if (!mounted || token == null) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.family_cloud_enter_name_first);
      return;
    }
    await _run(() async {
      await FamilyCloudService.requestJoin(token: token, name: name);
      await _refresh();
    });
  }

  Future<void> _resolveRequest(String requestId, bool approve) async {
    await _run(() async {
      await FamilyCloudService.resolveJoinRequest(
        requestId: requestId,
        approve: approve,
      );
      await _refresh();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _FamilyInviteScanner extends StatelessWidget {
  const _FamilyInviteScanner({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MobileScanner(
        onDetect: (capture) {
          if (capture.barcodes.isEmpty) return;
          final rawValue = capture.barcodes.first.rawValue;
          if (rawValue == null) return;
          final uri = Uri.tryParse(rawValue);
          if (uri == null ||
              uri.scheme != 'noya' ||
              uri.host != 'family' ||
              uri.path != '/join') {
            return;
          }
          final token = uri.queryParameters['token'];
          if (context.mounted && token != null && token.isNotEmpty) {
            Navigator.of(context).pop(token);
          }
        },
      ),
    );
  }
}

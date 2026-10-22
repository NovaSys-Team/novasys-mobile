import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/driver_verification.dart';
import 'driver_account_completion_view.dart';
import 'entry_views.dart';

const _teal = Color(0xFF0A7C70);
const _ink = Color(0xFF0F2A29);
const _muted = Color(0xFF5E6F6D);
const _green = Color(0xFF157A40);

class DriverVerificationView extends StatelessWidget {
  const DriverVerificationView({super.key, required this.auth});
  final AuthController auth;

  Future<void> _selectDocument(
    BuildContext context,
    DriverDocument document,
  ) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.title),
        content: Text(
          '${document.subtitle}.\n\nAdd a mock document for this demo. No file is selected or uploaded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add mock document'),
          ),
        ],
      ),
    );
    if (added == true && context.mounted && auth.user != null) {
      auth.driverVerification.addDocument(document);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F8F7),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListenableBuilder(
            listenable: auth.driverVerification,
            builder: (context, _) {
              final state = auth.driverVerification.verification;
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ProfileHeader(auth: auth),
                            const SizedBox(height: 12),
                            _StatusCard(status: state.status),
                            const SizedBox(height: 16),
                            if (state.canCompleteAccount)
                              const _NextStepCard()
                            else ...[
                              Semantics(
                                liveRegion: true,
                                child: Text(
                                  'Required documents · ${state.documents.length} of 4',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              for (final document in DriverDocument.values)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _DocumentCard(
                                    document: document,
                                    added: state.documents.contains(document),
                                    onUpload: () =>
                                        _selectDocument(context, document),
                                  ),
                                ),
                            ],
                            const Spacer(),
                            const SizedBox(height: 24),
                            _VerificationFooter(auth: auth, state: state),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final name = auth.user?.name.trim();
    final displayName = name == null || name.isEmpty
        ? 'Ruwan Jayasinghe'
        : name;
    final parts = displayName.split(RegExp(r'\s+'));
    final initials =
        '${parts.first.characters.first}${parts.length > 1 ? parts.last.characters.first : ''}'
            .toUpperCase();
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFCFE8E4),
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF0B3B3A),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.signedInWithGoogle
                    ? 'Signed in with Google'
                    : 'Signed in with phone',
                style: const TextStyle(
                  fontSize: 13,
                  color: _muted,
                  height: 1.4,
                ),
              ),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: _teal,
            padding: EdgeInsets.zero,
            minimumSize: const Size(60, 48),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => InitialView(controller: auth),
              ),
              (_) => false,
            );
          },
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});
  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final (title, description, background, foreground) = switch (status) {
      VerificationStatus.incomplete => (
        'Verify your documents',
        'Upload these 4 documents. An admin checks them, usually within 1 working day.',
        const Color(0xFF0B3B3A),
        Colors.white,
      ),
      VerificationStatus.pendingReview => (
        'Under review',
        "Thanks! An admin is checking your documents. We'll notify you.",
        const Color(0xFFFFF4DD),
        const Color(0xFF8A5A00),
      ),
      VerificationStatus.approved => (
        'You’re approved',
        'Your documents are verified. One more step before you can take students.',
        const Color(0xFFE5F6EC),
        _green,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.4,
                color: foreground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 14, height: 1.45, color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next: finish your account',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: _ink,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Vehicle details · price per km · schools you serve · your home point',
          style: TextStyle(fontSize: 14, height: 1.3, color: Color(0xFF4A5D5B)),
        ),
      ],
    ),
  );
}

class _VerificationFooter extends StatelessWidget {
  const _VerificationFooter({required this.auth, required this.state});
  final AuthController auth;
  final DriverVerification state;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Trips, requests and earnings unlock after admin approval.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, height: 1.5, color: _muted),
      ),
      const SizedBox(height: 14),
      if (state.status == VerificationStatus.pendingReview)
        if (auth.driverVerification.isDemo)
          CustomPaint(
            painter: const _DashedBorder(),
            child: TextButton(
              key: const Key('demo-approve'),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: const Color(0xFF4A5D5B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                auth.driverVerification.demoApprove();
              },
              child: const Text('Demo: admin approves'),
            ),
          )
        else
          const SizedBox(height: 48)
      else
        FilledButton(
          key: Key(
            state.canCompleteAccount
                ? 'complete-account'
                : 'submit-verification',
          ),
          style: FilledButton.styleFrom(
            backgroundColor: _teal,
            disabledBackgroundColor: const Color(0xFFE6EDEC),
            disabledForegroundColor: _muted,
            minimumSize: const Size(double.infinity, 54),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: state.canCompleteAccount
              ? () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DriverAccountCompletionView(),
                  ),
                )
              : state.canSubmit
              ? () {
                  if (auth.driverVerification.submit()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Documents submitted. An admin must approve them before trips, requests and earnings unlock.',
                        ),
                      ),
                    );
                  }
                }
              : null,
          child: Text(
            state.canCompleteAccount ? 'Complete account' : 'Submit for review',
          ),
        ),
    ],
  );
}

class _DashedBorder extends CustomPainter {
  const _DashedBorder();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(.5),
          const Radius.circular(14),
        ),
      );
    final paint = Paint()
      ..color = const Color(0xFF9AABA8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 4) {
        canvas.drawPath(metric.extractPath(offset, offset + 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorder oldDelegate) => false;
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.added,
    required this.onUpload,
  });
  final DriverDocument document;
  final bool added;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 72),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFDCE5E3), width: .8),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: added ? const Color(0xFFE4F4F2) : const Color(0xFFEEF2F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.insert_drive_file_outlined,
            size: 20,
            color: added ? _teal : const Color(0xFF4A5D5B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.title,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
              Text(
                document.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (added)
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: 15, color: _green),
              SizedBox(width: 4),
              Text(
                'Added',
                style: TextStyle(
                  color: _green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        else
          Semantics(
            label: 'Upload ${document.title}',
            button: true,
            child: SizedBox(
              height: 48,
              child: Center(
                child: FilledButton(
                  key: Key('upload-${document.name}'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    minimumSize: const Size(74, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onUpload,
                  child: const Text('Upload'),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

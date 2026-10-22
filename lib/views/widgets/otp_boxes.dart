import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/auth_theme.dart';

/// Six separate code boxes driven by one hidden field.
///
/// Keeping a single [TextField] underneath preserves platform one-time-code
/// autofill and paste, while the boxes above give the reference layout.
class OtpBoxes extends StatelessWidget {
  const OtpBoxes({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    this.focusNode,
    this.onSubmitted,
    this.length = 6,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;
  final int length;

  @override
  Widget build(BuildContext context) {
    final digits = controller.text;
    final active = digits.length.clamp(0, length - 1);
    return Semantics(
      label: '$length digit verification code',
      child: Stack(
        children: [
          Row(
            children: [
              for (var index = 0; index < length; index++) ...[
                if (index > 0) const SizedBox(width: 8),
                Expanded(
                  child: _OtpBox(
                    digit: index < digits.length ? digits[index] : '',
                    highlighted: enabled && index == active,
                  ),
                ),
              ],
            ],
          ),
          // Transparent capture layer: the real field sits over the boxes so a
          // tap anywhere in the row opens the keyboard.
          Positioned.fill(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              autofocus: true,
              showCursor: false,
              cursorColor: Colors.transparent,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(length),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
              onSubmitted: (_) => onSubmitted?.call(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.digit, required this.highlighted});
  final String digit;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 50.3 / 67.2,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted ? AuthTheme.mint : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuthTheme.teal, width: 1.6),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AuthTheme.ink,
          ),
        ),
      ),
    ),
  );
}

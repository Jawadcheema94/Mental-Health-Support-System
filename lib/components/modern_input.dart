import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernInput extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onTap;
  final bool readOnly;

  const ModernInput({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.errorText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<ModernInput> createState() => _ModernInputState();
}

class _ModernInputState extends State<ModernInput> {
  bool _isFocused = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
    _hasContent = widget.controller?.text.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasContent = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: widget.errorText != null
                  ? AppTheme.errorColor
                  : _isFocused
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused ? AppTheme.softShadow : null,
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              style: AppTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? AppTheme.primaryColor
                            : AppTheme.textLight,
                        size: 20,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          widget.suffixIcon,
                          color: _isFocused
                              ? AppTheme.primaryColor
                              : AppTheme.textLight,
                          size: 20,
                        ),
                        onPressed: widget.onSuffixIconPressed,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
                labelStyle: TextStyle(
                  color: _isFocused
                      ? AppTheme.primaryColor
                      : _hasContent
                          ? AppTheme.textSecondary
                          : AppTheme.textLight,
                  fontSize: _isFocused || _hasContent ? 12 : 16,
                  fontWeight: _isFocused ? FontWeight.w500 : FontWeight.normal,
                ),
                hintStyle: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 16,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordInput({
    super.key,
    this.label = 'Password',
    this.hint,
    this.controller,
    this.validator,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return ModernInput(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      validator: widget.validator,
      prefixIcon: Icons.lock_outline,
      suffixIcon: _isObscured ? Icons.visibility_off : Icons.visibility,
      onSuffixIconPressed: () {
        setState(() {
          _isObscured = !_isObscured;
        });
      },
      obscureText: _isObscured,
    );
  }
}

class SearchInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchInput({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: AppTheme.softShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textLight,
            size: 20,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingM,
          ),
          hintStyle: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

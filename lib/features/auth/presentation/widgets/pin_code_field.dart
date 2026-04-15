import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketi_app/core/themes/colors.dart';

class PinCodeField extends StatefulWidget {
  final int length;
  final void Function(String) onChanged;

  const PinCodeField({super.key, this.length = 4, required this.onChanged});

  @override
  State<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    String code = _controllers.map((e) => e.text).join();
    widget.onChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 65,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.greyScaleColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              _onChanged();
            },
          ),
        );
      }),
    );
  }
}

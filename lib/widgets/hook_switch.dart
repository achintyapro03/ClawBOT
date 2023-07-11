import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter code sample for [Switch].

class SwitchHook extends HookWidget {
  const SwitchHook({super.key, required this.light});

  final light;
  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }

        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }

        return null;
      },
    );
    return Switch(
      value: light.value,
      overlayColor: overlayColor,
      trackColor: trackColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      thumbColor:
          const MaterialStatePropertyAll<Color>(Color.fromARGB(208, 0, 4, 14)),
      onChanged: (bool value) {
        // setState(() {
        light.value = value;
        // });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_bolso/repositories/income_repository.dart';

class EditIncomeDialog extends StatefulWidget {
  final double currentIncome;

  const EditIncomeDialog({
    Key? key,
    required this.currentIncome,
  }) : super(key: key);

  @override
  State<EditIncomeDialog> createState() => _EditIncomeDialogState();
}

class _EditIncomeDialogState extends State<EditIncomeDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentIncome.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incomeRepo = Provider.of<IncomeRepository>(context, listen: false);

    return AlertDialog(
      title: const Text('Editar Renda Mensal'),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          prefixText: 'R\$ ',
          labelText: 'Valor',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final value =
                double.tryParse(_controller.text.replaceAll(',', '.'));
            if (value != null && value >= 0) {
              final incomeRepo =
                  Provider.of<IncomeRepository>(context, listen: false);
              incomeRepo.updateIncome(value).then((_) {
                Navigator.of(context).pop();
              });
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

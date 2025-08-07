import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';
import 'package:test_fund_managment/shared/models/form_validators.dart';
import '../../../../domain/entites/fund/fund.dart';
import '../../../../shared/components/forms/forms.dart';
import '../../../helpers/utils/utils.dart';

class SubscriptionFormWidget extends StatefulWidget {
  final Fund fund;
  final Function(double amount) onSubscribe;
  final VoidCallback? onCancel;
  final double availableAmount;

  const SubscriptionFormWidget({
    super.key,
    required this.fund,
    required this.onSubscribe,
    required this.availableAmount,
    this.onCancel,
  });

  @override
  State<SubscriptionFormWidget> createState() => _SubscriptionFormWidgetState();
}

class _SubscriptionFormWidgetState extends State<SubscriptionFormWidget> {
  final GlobalKey<DynamicFormState> _formKey = GlobalKey<DynamicFormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  List<FormFieldConfig> _getSubscriptionFields() {
    return [
      FormFieldConfig(
        name: 'amount',
        label: 'Monto a Invertir',
        type: FieldType.number,
        required: true,
        hintText: 'Ingrese el monto que desea invertir',
        validators: [
          FormValidators.required(message: 'El monto es requerido'),
          FormValidators.numeric(message: 'Ingrese un número válido'),
          FormValidators.min(
            widget.fund.minimumAmount,
            message:
                'El monto mínimo es ${UtilsApp.currencyFormat(widget.fund.minimumAmount, widget.fund.currency)}',
          ),
          FormValidators.max(
            widget.availableAmount,
            message:
                'El monto máximo disponible es ${UtilsApp.currencyFormat(widget.availableAmount, widget.fund.currency)}',
          ),
        ],
        onChanged: (value) {},
      ),
    ];
  }

  void _handleSubmit(Map<String, dynamic> data) {
    final amount = double.tryParse(data['amount']?.toString() ?? '');
    if (amount == null) {
      // Mostrar error de formato
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un monto válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount < widget.fund.minimumAmount) {
      // Mostrar error de monto mínimo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El monto mínimo es ${UtilsApp.currencyFormat(widget.fund.minimumAmount, widget.fund.currency)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSubscribe(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Información del fondo
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.fund.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Categoría: ${widget.fund.category}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Monto mínimo: ${UtilsApp.currencyFormat(widget.fund.minimumAmount, widget.fund.currency)}',
                      
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Disponible: ${UtilsApp.currencyFormat(widget.availableAmount, 'COP')}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Formulario dinámico con validación reactiva
        DynamicForm(
          key: _formKey,
          fields: _getSubscriptionFields(),
          enableReactiveValidation: true,
          onChanged: (values) {
            // Validar formulario cuando cambien los valores
            _validateForm();
          },
        ),

        const SizedBox(height: 24),

        // Botones de acción
        Row(
          children: [
            if (widget.onCancel != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        // Validar una vez más antes de enviar
                        if (_formKey.currentState?.validate() ?? false) {
                          final values = _formKey.currentState?.values ?? {};
                          _handleSubmit(values);
                        }
                      }
                    : null, // Deshabilitado cuando el formulario no es válido
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';
import 'package:test_fund_managment/shared/models/form_validators.dart';
import 'forms.dart';

/// Página de prueba para validar que los validadores funcionen correctamente
class ValidationTestPage extends StatefulWidget {
  const ValidationTestPage({super.key});

  @override
  State<ValidationTestPage> createState() => _ValidationTestPageState();
}

class _ValidationTestPageState extends State<ValidationTestPage> {
  final GlobalKey<DynamicFormState> _formKey = GlobalKey<DynamicFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Validación'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prueba de Validadores',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prueba los validadores escribiendo valores inválidos.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Formulario de prueba
            DynamicForm(
              key: _formKey,
              enableReactiveValidation: true,
              fields: _getTestFields(),
              onChanged: (values) {
                print('Valores del formulario: $values');
              },
            ),
            
            const SizedBox(height: 32),
            
            // Botones de prueba
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Llenar con valores inválidos para probar
                      _formKey.currentState?.setValue('amount', 'abc');
                      _formKey.currentState?.setValue('minAmount', '5');
                    },
                    child: const Text('Llenar Inválido'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState?.validate() ?? false;
                      final values = _formKey.currentState?.values ?? {};
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isValid 
                              ? 'Formulario válido: $values'
                              : 'Formulario inválido - revise los errores',
                          ),
                          backgroundColor: isValid ? Colors.green : Colors.red,
                        ),
                      );
                    },
                    child: const Text('Validar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FormFieldConfig> _getTestFields() {
    return [
      // Campo numérico básico
      FormFieldConfig(
        name: 'amount',
        label: 'Monto (Solo números)',
        type: FieldType.number,
        required: true,
        hintText: 'Ingrese un número',
        validators: [
          FormValidators.required(message: 'El monto es requerido'),
          FormValidators.numeric(message: 'Debe ser un número válido'),
        ],
      ),
      
      // Campo con validación de monto mínimo
      FormFieldConfig(
        name: 'minAmount',
        label: 'Monto Mínimo (>= 100)',
        type: FieldType.number,
        required: true,
        hintText: 'Ingrese un monto mayor a 100',
        validators: [
          FormValidators.required(message: 'El monto es requerido'),
          FormValidators.numeric(message: 'Debe ser un número válido'),
          FormValidators.min(100, message: 'El monto mínimo es 100'),
        ],
      ),
      
      // Campo de texto con validación
      FormFieldConfig(
        name: 'name',
        label: 'Nombre (Requerido)',
        type: FieldType.text,
        required: true,
        hintText: 'Ingrese su nombre',
        validators: [
          FormValidators.required(message: 'El nombre es requerido'),
        ],
      ),
    ];
  }
}

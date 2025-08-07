import 'package:flutter/material.dart';
import 'package:test_fund_managment/domain/usecases/app_usecases.dart';
import 'package:test_fund_managment/ui/helpers/utils/utils.dart';
import 'package:test_fund_managment/ui/pages/funds/widgets/subscription_form_widget.dart';

import '../../../config/app_config.dart';
import '../../../config/service_locator.dart';
import '../../../domain/entites/fund/fund.dart';
import '../../../domain/entites/fund/list_fund.dart';
import '../../../domain/entites/error/error_item.dart';
import '../../helpers/base_state.dart';
import '../../../shared/components/components.dart';
import '../../models/table_column_config.dart';
import '../../models/pagination_config.dart';
import 'interfaces/funds_page_interface.dart';
import 'presenter/funds_page_presenter.dart';

class FundsPage extends StatefulWidget {
  static const String routeName = '/funds';

  const FundsPage({super.key});

  @override
  State<FundsPage> createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage>
    with SafeStateMixin
    implements FundsPageInterface {
  ListFund _funds = ListFund(funds: []);
  bool _isLoading = true;
  String? _error;
  double _availableAmount = 500000;
  final AppUseCases _appUseCases = getIt<AppConfig>().appUseCases;
  late FundsPagePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = FundsPagePresenter(this, _appUseCases);
    _presenter.getFunds();
  }

  Widget _buildContent() {
    if (_error != null) {
      return SizedBox(
        height: 400, // Altura mínima para el estado de error
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar fondos',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _presenter.getFunds,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: 500, // Altura mínima para la tabla
      ),
      child: PaginatedTable<Fund>(
        data: _funds.funds,
        isLoading: _isLoading,
        columns: [
          TableColumnConfig<Fund>(
            header: 'ID',
            valueExtractor: (fund) => fund.id.toString(),
            flex: 1,
            sortable: true,
            alignment: TextAlign.center,
          ),
          TableColumnConfig<Fund>(
            header: 'Nombre',
            valueExtractor: (fund) => fund.name,
            flex: 1,
            sortable: true,
            alignment: TextAlign.left,
          ),
          TableColumnConfig<Fund>(
            header: 'Monto Mínimo',
            valueExtractor: (fund) =>
                UtilsApp.currencyFormat(fund.minimumAmount, fund.currency),
            flex: 1,
            sortable: true,
            alignment: TextAlign.right,
          ),
          TableColumnConfig<Fund>(
            header: 'Categoría',
            valueExtractor: (fund) => fund.category,
            cellBuilder: (fund) => _buildCategoryChip(fund.category),
            flex: 1,
            sortable: true,
            alignment: TextAlign.center,
          ),
          TableColumnConfig<Fund>(
            header: 'Acciones',
            valueExtractor: (fund) => '',
            cellBuilder: (fund) => _buildActionButtons(fund),
            flex: 1,
            alignment: TextAlign.center,
          ),
        ],
        paginationConfig: const PaginationConfig(
          itemsPerPage: 10,
          itemsPerPageOptions: [5, 10, 25, 50],
          showItemsPerPageSelector: true,
          showPageNumbers: true,
          maxPageNumbersToShow: 5,
        ),
        onRowTap: (fund) => _showFundDetails(fund),
        emptyMessage: 'No hay fondos registrados',
        alternateRowColor: Colors.grey.shade50,
        showBorder: true,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Chip(
      label: Text(category, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildActionButtons(Fund fund) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, size: 18),
          onPressed: () => _showFundDetails(fund),
          tooltip: 'Ver detalles',
        ),
        ElevatedButton(
          onPressed: () => _showSubscriptionDialog(fund),
          child: const Text('Subscribirse'),
        ),
      ],
    );
  }

  void _showCreateFundDialog() {
    AppModal.showInfo(
      context: context,
      title: 'Crear Nuevo Fondo',
      message: 'Funcionalidad de creación de fondos próximamente...',
      icon: Icon(
        Icons.add_circle_outline,
        color: Theme.of(context).primaryColor,
        size: 48,
      ),
    );
  }

  void _showFundDetails(Fund fund) {
    AppModal.showInfo(
      context: context,
      title: 'Detalles del Fondo',
      message: 'Información completa del fondo seleccionado',
      icon: Icon(
        Icons.info_outline,
        color: Theme.of(context).primaryColor,
        size: 48,
      ),
      content: _buildFundDetailsContent(fund),
    );
  }

  Widget _buildFundDetailsContent(Fund fund) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del fondo
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
                  fund.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Información detallada
          _buildDetailRow('ID', fund.id.toString(), Icons.tag),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Monto Mínimo',
            UtilsApp.currencyFormat(fund.minimumAmount, fund.currency),
            Icons.monetization_on,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Categoría', fund.category, Icons.category),
          const SizedBox(height: 12),
          _buildDetailRow('Moneda', fund.currency, Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSubscriptionDialog(Fund fund) {
    AppModal.showCustom(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header del modal
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Suscripción al Fondo',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Widget de suscripción con formulario
            SubscriptionFormWidget(
              fund: fund,
              onSubscribe: (amount) {
                Navigator.of(context).pop();
                _confirmSubscription(fund, amount);
              },
              onCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSubscription(Fund fund, double amount) {
    AppModal.showSuccessSnackBar(
      context: context,
      message:
          'Suscripción exitosa para ${fund.name}\nMonto invertido: ${UtilsApp.currencyFormat(amount, fund.currency)}',
      actionLabel: 'Ver detalles',
      onActionPressed: () => _showFundDetails(fund),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60), // Espaciado superior
        // Icono principal
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 32),

        // Título principal
        Text(
          '¡Comienza tu inversión!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),

        // Descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Aún no tienes fondos disponibles.\nExplora nuestras opciones de inversión y encuentra el fondo perfecto para ti.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 60), // Espaciado inferior
      ],
    );
  }

  void updateAvailableAmount(double newAmount) {
    safeSetState(() {
      _availableAmount = newAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fondos de Inversión',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showCreateFundDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Fondo'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tarjeta de monto disponible
            BalanceCard(
              availableAmount: UtilsApp.currencyFormat(_availableAmount, 'COP'),
              title: 'Monto Disponible',
              subtitle: 'Para inversiones en fondos',
              icon: Icons.account_balance_wallet,
              onTap: () {
                // Acción opcional al hacer tap en la tarjeta
                AppModal.showInfo(
                  context: context,
                  title: 'Monto Disponible',
                  message:
                      'Tienes ${UtilsApp.currencyFormat(_availableAmount, 'COP')} disponibles para invertir en fondos.',
                  icon: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Contenido principal - sin Expanded para permitir scroll
            _funds.funds.isEmpty && !_isLoading
                ? _buildEmptyState()
                : _buildContent(),
          ],
        ),
      ),
    );
  }

  @override
  void hideLoadingGetFunds() {
    _isLoading = false;
    safeSetState(() {});
  }

  @override
  void showErrorGetFunds(ErrorItem errorItem) {
    _error = errorItem.message;
    safeSetState(() {});
  }

  @override
  void showLoadingGetFunds() {
    _isLoading = true;
    safeSetState(() {});
  }

  @override
  void showSuccessGetFunds(ListFund listFund) {
    _funds = listFund;
    safeSetState(() {});
  }
}

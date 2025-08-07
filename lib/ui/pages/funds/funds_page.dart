import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_fund_managment/domain/usecases/app_usecases.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_bloc.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_event.dart';
import 'package:test_fund_managment/ui/bloc/funds/funds_bloc.dart';
import 'package:test_fund_managment/ui/bloc/funds/funds_event.dart';
import 'package:test_fund_managment/ui/bloc/funds/funds_state.dart';
import 'package:test_fund_managment/ui/helpers/utils/utils.dart';
import 'package:test_fund_managment/ui/pages/funds/widgets/subscription_form_widget.dart';

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
  final AppUseCases _appUseCases = getIt<AppUseCases>();
  late FundsPagePresenter _presenter;

  // Variables de estado local sincronizadas con BLoC
  double _availableAmount = 500000;
  Map<int, double> _subscriptions = {};

  @override
  void initState() {
    super.initState();
    _presenter = FundsPagePresenter(this, _appUseCases);
    _presenter.getFunds();

    // Cargar estado inicial del BLoC
    context.read<FundsBloc>().add(const LoadFundsState());

    // Sincronizar variables locales con el estado del BLoC
    _syncWithBlocState();
  }

  Widget _buildErrorTable() {
    return SizedBox(
      height: 400,
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

  Widget _buildContent() {
    if (_error != null) {
      return _buildErrorTable();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Usar tarjetas en pantallas pequeñas (móviles)
        if (constraints.maxWidth < 768) {
          return _buildMobileView();
        } else {
          // Usar tabla en pantallas grandes (tablets/desktop)
          return _buildTableView();
        }
      },
    );
  }

  Widget _buildTableView() {
    return Container(
      constraints: BoxConstraints(minHeight: 500),
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

  Widget _buildMobileView() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_funds.funds.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No hay fondos registrados'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _funds.funds.length,
      itemBuilder: (context, index) {
        final fund = _funds.funds[index];
        final isSubscribed = _subscriptions.containsKey(fund.id);
        final investedAmount = _subscriptions[fund.id];

        return FundCard(
          fund: fund,
          isSubscribed: isSubscribed,
          investedAmount: investedAmount,
          onViewDetails: () => _showFundDetails(fund),
          onSubscribe: () => _showSubscriptionDialog(fund),
          onUnsubscribe: isSubscribed && investedAmount != null
              ? () => _showUnsubscribeDialog(fund, investedAmount)
              : null,
        );
      },
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
    final bool isSubscribed = _subscriptions.containsKey(fund.id);
    final double? investedAmount = _subscriptions[fund.id];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, size: 18),
          onPressed: () => _showFundDetails(fund),
          tooltip: 'Ver detalles',
        ),
        ElevatedButton(
          onPressed: () => isSubscribed
              ? _showUnsubscribeDialog(fund, investedAmount!)
              : _showSubscriptionDialog(fund),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubscribed ? Colors.red : null,
            foregroundColor: isSubscribed ? Colors.white : null,
          ),
          child: Text(isSubscribed ? 'Desuscribir' : 'Suscribir'),
        ),
      ],
    );
  }

  Widget _buildSubscriptionStatusRow(Fund fund) {
    final bool isSubscribed = _subscriptions.containsKey(fund.id);
    final double? investedAmount = _subscriptions[fund.id];

    return isSubscribed && investedAmount != null
        ? _buildSubscribedStatusRow(fund, investedAmount)
        : _buildNotSubscribedStatusRow();
  }

  Widget _buildSubscribedStatusRow(Fund fund, double investedAmount) {
    return Row(
      children: [
        _buildStatusIcon(Icons.check_circle, Colors.green.shade600),
        const SizedBox(width: 8),
        _buildStatusLabel(),
        const SizedBox(width: 4),
        Expanded(child: _buildSubscribedStatusContent(fund, investedAmount)),
      ],
    );
  }

  Widget _buildNotSubscribedStatusRow() {
    return Row(
      children: [
        _buildStatusIcon(Icons.radio_button_unchecked, Colors.grey.shade500),
        const SizedBox(width: 8),
        _buildStatusLabel(),
        const SizedBox(width: 4),
        Expanded(child: _buildNotSubscribedStatusContent()),
      ],
    );
  }

  Widget _buildStatusIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildStatusLabel() {
    return Text(
      'Estado:',
      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
    );
  }

  Widget _buildSubscribedStatusContent(Fund fund, double investedAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suscrito',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
            fontSize: 14,
          ),
        ),
        Text(
          'Invertido: ${UtilsApp.currencyFormat(investedAmount, fund.currency)}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNotSubscribedStatusContent() {
    return Text(
      'No suscrito',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        fontSize: 14,
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
          const SizedBox(height: 12),
          _buildSubscriptionStatusRow(fund),
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
      child: Builder(
        builder: (dialogContext) => Padding(
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
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Widget de suscripción con formulario
              SubscriptionFormWidget(
                fund: fund,
                availableAmount: _availableAmount,
                onSubscribe: (amount) {
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                  _confirmSubscription(fund, amount);
                },
                onCancel: () {
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnsubscribeDialog(Fund fund, double investedAmount) {
    AppModal.showConfirmation(
      context: context,
      title: 'Confirmar',
      message:
          '¿Deseas desuscribirte del fondo "${fund.name}"?\n\nRecuperarás: ${UtilsApp.currencyFormat(investedAmount, fund.currency)}',
      icon: Icon(Icons.warning, color: Colors.orange, size: 48),
      confirmText: 'Desuscribir',
      cancelText: 'Cancelar',
      onConfirm: () => _confirmUnsubscription(fund, investedAmount),
    );
  }

  void _confirmUnsubscription(Fund fund, double investedAmount) {
    // Enviar evento al BLoC para actualizar el estado
    context.read<FundsBloc>().add(UnsubscribeFromFund(fundId: fund.id));

    // Agregar notificación de desuscripción
    context.read<NotificationsBloc>().add(
      AddUnsubscriptionNotification(
        fundName: fund.name,
        amount: investedAmount,
        currency: fund.currency,
      ),
    );

    // Mostrar mensaje de confirmación
    AppModal.showSuccessSnackBar(
      context: context,
      message:
          'Desuscripción exitosa de ${fund.name}\nMonto recuperado: ${UtilsApp.currencyFormat(investedAmount, fund.currency)}\nBalance actual: ${UtilsApp.currencyFormat(_availableAmount, fund.currency)}',
      actionLabel: 'Ver balance',
      onActionPressed: () {
        AppModal.showInfo(
          context: context,
          title: 'Balance Actualizado',
          message:
              'Tu balance actual es: ${UtilsApp.currencyFormat(_availableAmount, fund.currency)}',
          icon: Icon(
            Icons.account_balance_wallet,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  void _confirmSubscription(Fund fund, double amount) {
    // Verificar que hay fondos suficientes
    if (amount > _availableAmount) {
      AppModal.showErrorSnackBar(
        context: context,
        message:
            'Fondos insuficientes. Disponible: ${UtilsApp.currencyFormat(_availableAmount, fund.currency)}',
        actionLabel: 'Ver balance',
        onActionPressed: () {
          AppModal.showInfo(
            context: context,
            title: 'Balance Disponible',
            message:
                'Tienes ${UtilsApp.currencyFormat(_availableAmount, fund.currency)} disponibles para invertir.',
            icon: Icon(
              Icons.account_balance_wallet,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      );
      return;
    }

    // Enviar evento al BLoC para actualizar el estado
    context.read<FundsBloc>().add(
      SubscribeToFund(fundId: fund.id, amount: amount),
    );

    // Agregar notificación de suscripción
    context.read<NotificationsBloc>().add(
      AddSubscriptionNotification(
        fundName: fund.name,
        amount: amount,
        currency: fund.currency,
      ),
    );

    // Mostrar mensaje de éxito con información actualizada
    AppModal.showSuccessSnackBar(
      context: context,
      message:
          'Suscripción exitosa para ${fund.name}\nMonto invertido: ${UtilsApp.currencyFormat(amount, fund.currency)}\nBalance restante: ${UtilsApp.currencyFormat(_availableAmount, fund.currency)}',
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

  // Método para sincronizar variables locales con el estado del BLoC
  void _syncWithBlocState() {
    final fundsState = context.read<FundsBloc>().state;
    if (fundsState is FundsLoaded) {
      safeSetState(() {
        _availableAmount = fundsState.availableAmount;
        _subscriptions = Map.from(fundsState.subscriptions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FundsBloc, FundsState>(
      listener: (context, state) {
        // Sincronizar variables locales cuando cambie el estado del BLoC
        if (state is FundsLoaded) {
          safeSetState(() {
            _availableAmount = state.availableAmount;
            _subscriptions = Map.from(state.subscriptions);
          });
        }
      },
      child: Scaffold(
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
                ],
              ),
              const SizedBox(height: 24),

              // Tarjeta de monto disponible
              BalanceCard(
                availableAmount: UtilsApp.currencyFormat(
                  _availableAmount,
                  'COP',
                ),
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

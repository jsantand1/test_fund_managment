import 'package:flutter/material.dart';
import '../../domain/entites/fund/fund.dart';
import '../../ui/helpers/utils/utils.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final bool isSubscribed;
  final double? investedAmount;
  final VoidCallback onViewDetails;
  final VoidCallback onSubscribe;
  final VoidCallback? onUnsubscribe;

  const FundCard({
    super.key,
    required this.fund,
    required this.isSubscribed,
    this.investedAmount,
    required this.onViewDetails,
    required this.onSubscribe,
    this.onUnsubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ID y nombre
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ID: ${fund.id}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fund.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Información del fondo
            _buildInfoRow(
              icon: Icons.monetization_on,
              label: 'Monto Mínimo',
              value: UtilsApp.currencyFormat(fund.minimumAmount, fund.currency),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.category,
              label: 'Categoría',
              value: fund.category,
              isCategory: true,
            ),
            const SizedBox(height: 12),

            // Estado de suscripción
            _buildSubscriptionStatus(),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver Detalles'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSubscribed ? onUnsubscribe : onSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubscribed ? Colors.red : null,
                      foregroundColor: isSubscribed ? Colors.white : null,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(isSubscribed ? 'Desuscribir' : 'Suscribir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isCategory = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isCategory)
          Chip(
            label: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        else
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubscriptionStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSubscribed 
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSubscribed 
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSubscribed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: isSubscribed ? Colors.green[600] : Colors.grey[500],
          ),
          const SizedBox(width: 8),
          Text(
            'Estado: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSubscribed ? 'Suscrito' : 'No suscrito',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSubscribed ? Colors.green[700] : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                if (isSubscribed && investedAmount != null)
                  Text(
                    'Invertido: ${UtilsApp.currencyFormat(investedAmount!, fund.currency)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

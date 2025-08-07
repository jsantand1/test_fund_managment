import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String availableAmount;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const BalanceCard({
    super.key,
    required this.availableAmount,
    this.title = 'Monto Disponible',
    this.subtitle = 'Para inversiones',
    this.icon = Icons.account_balance_wallet,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor ?? Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      availableAmount,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: textColor ?? Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor?.withOpacity(0.7) ?? Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Trailing widget opcional
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

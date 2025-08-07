import 'package:flutter/material.dart';
import 'package:test_fund_managment/ui/models/pagination_config.dart';
import 'package:test_fund_managment/ui/models/table_column_config.dart';

/// Componente de tabla paginada genérica
class PaginatedTable<T> extends StatefulWidget {
  final List<T> data;
  final List<TableColumnConfig<T>> columns;
  final PaginationConfig paginationConfig;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? loadingWidget;
  final Function(T item)? onRowTap;
  final Color? headerColor;
  final Color? alternateRowColor;
  final bool showBorder;
  final EdgeInsets? padding;

  const PaginatedTable({
    Key? key,
    required this.data,
    required this.columns,
    this.paginationConfig = const PaginationConfig(),
    this.isLoading = false,
    this.emptyMessage,
    this.loadingWidget,
    this.onRowTap,
    this.headerColor,
    this.alternateRowColor,
    this.showBorder = true,
    this.padding,
  }) : super(key: key);

  @override
  State<PaginatedTable<T>> createState() => _PaginatedTableState<T>();
}

class _PaginatedTableState<T> extends State<PaginatedTable<T>> {
  int _currentPage = 0;
  int _itemsPerPage = 10;
  String? _sortColumn;
  bool _sortAscending = true;
  List<T> _sortedData = [];

  @override
  void initState() {
    super.initState();
    _itemsPerPage = widget.paginationConfig.itemsPerPage;
    _updateSortedData();
  }

  @override
  void didUpdateWidget(PaginatedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _updateSortedData();
      // Reset to first page if data changed
      if (totalPages > 0 && _currentPage >= totalPages) {
        _currentPage = 0;
      }
    }
  }

  void _updateSortedData() {
    _sortedData = List<T>.from(widget.data);
    if (_sortColumn != null) {
      _applySorting();
    }
  }

  void _applySorting() {
    final column = widget.columns.firstWhere(
      (col) => col.header == _sortColumn,
    );
    
    _sortedData.sort((a, b) {
      final valueA = column.valueExtractor(a);
      final valueB = column.valueExtractor(b);
      
      int comparison = valueA.compareTo(valueB);
      return _sortAscending ? comparison : -comparison;
    });
  }

  void _onSort(String columnHeader) {
    setState(() {
      if (_sortColumn == columnHeader) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = columnHeader;
        _sortAscending = true;
      }
      _applySorting();
    });
  }

  int get totalPages {
    if (_sortedData.isEmpty || _itemsPerPage <= 0) return 1;
    return (_sortedData.length / _itemsPerPage).ceil();
  }
  
  List<T> get currentPageData {
    if (_sortedData.isEmpty) return [];
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, _sortedData.length);
    return _sortedData.sublist(startIndex, endIndex);
  }

  void _goToPage(int page) {
    setState(() {
      final maxPage = totalPages > 0 ? totalPages - 1 : 0;
      _currentPage = page.clamp(0, maxPage);
    });
  }

  void _changeItemsPerPage(int newItemsPerPage) {
    setState(() {
      _itemsPerPage = newItemsPerPage;
      _currentPage = 0; // Reset to first page
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tabla
        _buildTable(theme),
        
        // Información y controles de paginación
        if (_sortedData.isNotEmpty) _buildPaginationControls(theme),
      ],
    );
  }

  Widget _buildTable(ThemeData theme) {
    if (widget.isLoading) {
      return Container(
        height: 200,
        child: widget.loadingWidget ?? 
            const Center(child: CircularProgressIndicator()),
      );
    }

    if (_sortedData.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            widget.emptyMessage ?? 'No hay datos disponibles',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Container(
      
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 32, // Padding de la página
        ),
        child: IntrinsicWidth(
          child: Column(
            children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: widget.headerColor ?? theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: widget.columns.asMap().entries.map((entry) {
              final index = entry.key;
              final column = entry.value;
              final isLast = index == widget.columns.length - 1;
              
              return Flexible(
                child: InkWell(
                  onTap: column.sortable ? () => _onSort(column.header) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: !isLast ? Border(
                        right: BorderSide(
                          color: theme.dividerColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: _getMainAxisAlignment(column.alignment),
                      children: [
                        Flexible(
                          child: Text(
                            column.header,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: column.alignment,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (column.sortable) ...[
                          const SizedBox(width: 4),
                          Icon(
                            _sortColumn == column.header
                                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                                : Icons.unfold_more,
                            size: 16,
                            color: _sortColumn == column.header
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Rows
        ...currentPageData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isEvenRow = index % 2 == 0;
          
          return InkWell(
            onTap: widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.alternateRowColor != null && !isEvenRow
                    ? widget.alternateRowColor!
                    : null,
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: widget.columns.asMap().entries.map((entry) {
                  final colIndex = entry.key;
                  final column = entry.value;
                  final isLast = colIndex == widget.columns.length - 1;
                  
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: !isLast ? Border(
                          right: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ) : null,
                      ),
                      child: Align(
                        alignment: _getAlignment(column.alignment),
                        child: column.cellBuilder != null
                            ? column.cellBuilder!(item)
                            : Text(
                                column.valueExtractor(item),
                                style: theme.textTheme.bodyMedium,
                                textAlign: column.alignment,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(ThemeData theme) {
    final startItem = _sortedData.isEmpty ? 0 : _currentPage * _itemsPerPage + 1;
    final endItem = _sortedData.isEmpty ? 0 : ((_currentPage + 1) * _itemsPerPage).clamp(0, _sortedData.length);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Información de elementos mostrados
          Text(
            'Mostrando $startItem-$endItem de ${_sortedData.length} elementos',
            style: theme.textTheme.bodySmall,
          ),
          
          const Spacer(),
          
          // Selector de elementos por página
          if (widget.paginationConfig.showItemsPerPageSelector) ...[
            Text(
              'Elementos por página: ',
              style: theme.textTheme.bodySmall,
            ),
            DropdownButton<int>(
              value: _itemsPerPage,
              underline: Container(),
              items: widget.paginationConfig.itemsPerPageOptions
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) _changeItemsPerPage(value);
              },
            ),
            const SizedBox(width: 24),
          ],
          
          // Controles de navegación
          IconButton(
            onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Página anterior',
          ),
          
          // Números de página
          if (widget.paginationConfig.showPageNumbers)
            ..._buildPageNumbers(theme),
          
          IconButton(
            onPressed: totalPages > 1 && _currentPage < totalPages - 1 
                ? () => _goToPage(_currentPage + 1) 
                : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Página siguiente',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(ThemeData theme) {
    if (totalPages <= 1) return [];
    
    final maxPages = widget.paginationConfig.maxPageNumbersToShow;
    final List<Widget> pageNumbers = [];
    
    final maxPagesToShow = maxPages.clamp(1, totalPages);
    final maxStartPage = (totalPages - maxPagesToShow).clamp(0, totalPages - 1);
    
    int startPage = (_currentPage - maxPagesToShow ~/ 2).clamp(0, maxStartPage);
    int endPage = (startPage + maxPagesToShow).clamp(1, totalPages);
    startPage = (endPage - maxPagesToShow).clamp(0, maxStartPage);
    
    // Botón para primera página si no está visible
    if (startPage > 0) {
      pageNumbers.add(_buildPageButton(0, theme));
      if (startPage > 1) {
        pageNumbers.add(Text('...', style: theme.textTheme.bodySmall));
      }
    }
    
    // Páginas visibles
    for (int i = startPage; i < endPage; i++) {
      pageNumbers.add(_buildPageButton(i, theme));
    }
    
    // Botón para última página si no está visible
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbers.add(Text('...', style: theme.textTheme.bodySmall));
      }
      pageNumbers.add(_buildPageButton(totalPages - 1, theme));
    }
    
    return pageNumbers;
  }

  Widget _buildPageButton(int page, ThemeData theme) {
    final isCurrentPage = page == _currentPage;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isCurrentPage ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _goToPage(page),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              (page + 1).toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isCurrentPage 
                    ? theme.colorScheme.onPrimary 
                    : theme.colorScheme.onSurface,
                fontWeight: isCurrentPage ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.left:
      case TextAlign.start:
        return MainAxisAlignment.start;
      case TextAlign.right:
      case TextAlign.end:
        return MainAxisAlignment.end;
      case TextAlign.center:
        return MainAxisAlignment.center;
      default:
        return MainAxisAlignment.start;
    }
  }

  Alignment _getAlignment(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}

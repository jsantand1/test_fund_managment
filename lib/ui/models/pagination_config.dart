
/// Configuración de paginación
class PaginationConfig {
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final bool showItemsPerPageSelector;
  final bool showPageNumbers;
  final int maxPageNumbersToShow;

  const PaginationConfig({
    this.itemsPerPage = 10,
    this.itemsPerPageOptions = const [5, 10, 25, 50],
    this.showItemsPerPageSelector = true,
    this.showPageNumbers = true,
    this.maxPageNumbersToShow = 5,
  });
}

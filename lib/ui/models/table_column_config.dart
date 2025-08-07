import 'dart:ui';
import 'package:flutter/material.dart';

/// Modelo para definir una columna de la tabla
class TableColumnConfig<T> {
  final String header;
  final String Function(T item) valueExtractor;
  final Widget Function(T item)? cellBuilder;
  final double? width;
  final int? flex;
  final bool sortable;
  final TextAlign alignment;

  const TableColumnConfig({
    required this.header,
    required this.valueExtractor,
    this.cellBuilder,
    this.width,
    this.flex,
    this.sortable = false,
    this.alignment = TextAlign.left,
  });
}
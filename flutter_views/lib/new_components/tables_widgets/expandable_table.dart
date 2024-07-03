import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTable2 extends StatefulWidget {
  const ExpandableTable2({super.key});

  @override
  State<ExpandableTable2> createState() => _ExpandableTableState2();
}

class _ExpandableTableState2 extends State<ExpandableTable2> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  ExpandableTable _buildSimpleTable() {
    const int columnsCount = 20;
    const int rowsCount = 20;
    //Creation header
    List<ExpandableTableHeader> headers = List.generate(
      columnsCount - 1,
      (index) => ExpandableTableHeader(
        width: index % 2 == 0 ? 200 : 150,
        cell: _buildCell('Column $index'),
      ),
    );
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: rowIndex % 2 == 0 ? 50 : 70,
        firstCell: _buildCell('Row $rowIndex'),
        cells: List<ExpandableTableCell>.generate(
          columnsCount - 1,
          (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Simple\nTable'),
      headers: headers,
      // scrollShadowColor: accentColor,
      rows: rows,
    );
  }

  static const int columnsCount = 20;
  static const int subColumnsCount = 2;
  static const int rowsCount = 6;
  static const int subRowsCount = 3;
  static const int totalColumns = columnsCount + subColumnsCount;
  ExpandableTableCell _buildFirstRowCell() {
    return ExpandableTableCell(
      builder: (context, details) => DefaultCellCard(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24 * details.row!.address.length.toDouble(),
                child: details.row?.children != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500),
                          turns:
                              details.row?.childrenExpanded == true ? 0.25 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
              Text(
                '${details.row!.address.length > 1 ? details.row!.address.skip(1).map((e) => 'Sub ').join() : ''}Row ${details.row!.address.last}',
                // style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ExpandableTableRow> _generateRows(int quantity, {int depth = 0}) {
    bool generateLegendRow = (depth == 0 || depth == 2);
    return List.generate(
      quantity,
      (rowIndex) => ExpandableTableRow(
        firstCell: _buildFirstRowCell(),
        children: ((rowIndex == 3 || rowIndex == 2) && depth < 3)
            ? _generateRows(subRowsCount, depth: depth + 1)
            : null,
        cells: !(generateLegendRow && (rowIndex == 3 || rowIndex == 2))
            ? List<ExpandableTableCell>.generate(
                totalColumns,
                (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
              )
            : null,
        legend: generateLegendRow && (rowIndex == 3 || rowIndex == 2)
            ? const DefaultCellCard(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text(
                      'This is row legend',
                      // style: textStyle,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  ExpandableTable _buildExpandableTable() {
    //Creation header
    List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell('Sub Column $index'),
      ),
    );

    //Creation header
    List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
          cell: _buildCell(
              '${index == 1 ? 'Expandable\nColumn' : 'Column'} $index'),
          children: index == 1 ? subHeader : null),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Expandable\nTable'),

      rows: _generateRows(rowsCount),
      headers: headers,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 150,
      firstColumnWidth: 250,
      // scrollShadowColor: accentColor,
    );
  }

  _buildCell(String content, {CellBuilder? builder}) {
    return ExpandableTableCell(
      child: builder != null
          ? null
          : DefaultCellCard(
              child: Center(
                child: Text(
                  content,
                  // style: textStyle,
                ),
              ),
            ),
      builder: builder,
    );
  }
}

class DefaultCellCard extends StatelessWidget {
  final Widget child;

  const DefaultCellCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: primaryColor,
      margin: const EdgeInsets.all(1),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/filter_data.dart';
import 'package:iot_devices_manager_app/models/responses/iot.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:provider/provider.dart';

import '../../common/date_format.dart';

class TableWidget extends StatefulWidget {
  int sensorId;

  TableWidget({
    required this.sensorId,
    Key? key,
  }) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final List<int> _availableRowsPerPage = [5, 10, 20, 50, 100];
  int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;
  late Sensor _sensor;

  var _sortAscending = true;
  var _sortColumnIndex = 0;

  void _sortData(List<DataResponse> data, int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      // Sort the data list based on the selected column and sort order
      data.sort((a, b) {
        final aValue = a.date;
        final bValue = b.date;
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  List<DataColumn> _getColumns(List<DataResponse> data) {
    return [
      DataColumn(
        label: CustomColumnText('Timestamp'),
        onSort: (columnIndex, ascending) {
          _sortData(data, columnIndex, ascending);
        },
      ),
      DataColumn(
        label: CustomColumnText('Average (${_sensor.getUnit()})'),
        onSort: null,
      ),
      DataColumn(
        label: CustomColumnText('Minimum (${_sensor.getUnit()})'),
        onSort: null,
      ),
      DataColumn(
        label: CustomColumnText('Maximum (${_sensor.getUnit()})'),
        onSort: null,
      ),
    ];
  }

  int _getRowPerPage(int currentListLength) {
    if (!_availableRowsPerPage.contains(_rowPerPage) && _rowPerPage != currentListLength) {
      return 10;
    }
    return _rowPerPage;
  }

  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<IoTDevices>(context, listen: false);
    _sensor = devices.getSensorById(widget.sensorId);
    return SingleChildScrollView(
      child: Consumer<FilterResponse>(builder: (ctx, filterResponse, _) {
        return PaginatedDataTable(
          rowsPerPage: _getRowPerPage(filterResponse.data.length),
          availableRowsPerPage: [..._availableRowsPerPage, filterResponse.data.length],
          onRowsPerPageChanged: (value) {
            if (value != null) {
              setState(() {
                _rowPerPage = value;
              });
            }
          },
          columns: _getColumns(filterResponse.data),
          source: _DeviceDataSource(filterResponse, filterResponse.data.length),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
        );
      }),
    );
  }
}

class _DeviceDataSource extends DataTableSource {
  int _selectedCount = 0;
  final FilterResponse _filterResponse;

  _DeviceDataSource(this._filterResponse, this._selectedCount);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _filterResponse.data.length) {
      return null;
    }
    final DataResponse data = _filterResponse.data[index];
    return DataRow.byIndex(
      color: MaterialStateProperty.all<Color>(Colors.white),
      index: index,
      selected: data.selected,
      onSelectChanged: (value) {
        if (value == null) {
          return;
        }
        if (data.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          data.setSelected = value;
          notifyListeners();
          _filterResponse.toggleRebuild();
        }
      },
      cells: [
        DataCell(CustomCellText(DateFormatter.dateTime(data.date))),
        DataCell(CustomCellText(data.avgValue.toString())),
        DataCell(CustomCellText(data.minValue.toString())),
        DataCell(CustomCellText(data.maxValue.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _filterResponse.data.length;

  @override
  int get selectedRowCount => _selectedCount;
}

class CustomColumnText extends StatelessWidget {
  String text;

  CustomColumnText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomCellText extends StatelessWidget {
  String text;

  CustomCellText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}

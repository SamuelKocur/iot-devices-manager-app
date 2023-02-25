import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/data.dart';
import 'package:iot_devices_manager_app/models/responses/iot.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:provider/provider.dart';

import '../../common/date_format.dart';
import '../../models/data_filtering.dart';

class TableWidget extends StatefulWidget {
  DateRange dateRange;
  int sensorId;
  List<SensorData> sensorData;

  TableWidget({
    required this.sensorId,
    required this.sensorData,
    required this.dateRange,
    Key? key,
  }) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;
  late Sensor _sensor;

  var _sortAscending = true;
  var _sortColumnIndex = 0;

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      // Sort the data list based on the selected column and sort order
      widget.sensorData.sort((a, b) {
        final aValue = a.date;
        final bValue = b.date;
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  List<DataColumn> _getColumns() {
    return [
      DataColumn(
        label: CustomColumnText('Timestamp'),
        onSort: (columnIndex, ascending) {
          _sortData(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: CustomColumnText('Average (${_sensor.getUnit()})'),
        onSort: (columnIndex, ascending) {
          _sortData(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: CustomColumnText('Minimum (${_sensor.getUnit()})'),
        onSort: (columnIndex, ascending) {
          _sortData(columnIndex, ascending);
        },
      ),
      DataColumn(

        label: CustomColumnText('Maximum (${_sensor.getUnit()})'),
        onSort: (columnIndex, ascending) {
          _sortData(columnIndex, ascending);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<IoTDevices>(context, listen: false);
    _sensor = devices.getSensorById(widget.sensorId);
    return SingleChildScrollView(
        child: PaginatedDataTable(
          rowsPerPage: _rowPerPage,
          availableRowsPerPage: const[5, 10, 20, 50],
          onRowsPerPageChanged: (value) {
            if (value != null) {
              setState(() {
                _rowPerPage = value;
              });
            }
          },
          columns: _getColumns(),
          source: _DeviceDataSource(widget.sensorData),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
        ),
    );
  }
}

class _DeviceDataSource extends DataTableSource {
  int _selectedCount = 0;
  final List<SensorData> _sensorData;

  _DeviceDataSource(this._sensorData);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _sensorData.length) {
      return null;
    }
    final SensorData data = _sensorData[index];
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
          data.selected = value;
          notifyListeners();
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
  int get rowCount => _sensorData.length;

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


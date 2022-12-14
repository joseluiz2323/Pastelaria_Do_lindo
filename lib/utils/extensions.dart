import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get formatted {
    return '$dataFormatted $hourFormatted';
  }

  DateTime get start {
    return DateTime(year, month, day);
  }

  DateTime get end {
    return DateTime(year, month, day, 23, 59, 59);
  }

  String get dataFormatted {
    final dia =
        '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year.toString().padLeft(4, '0')}';
    return dia;
  }

  String get hourFormatted {
    final hora =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
    return hora;
  }
}

//formatar valor em reais
extension DoubleExt on double {
  String get formatted {
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    return 'R\$ ${formatter.format(this)}';
  }
}

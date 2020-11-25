import 'commands/open.dart';
import 'commands/close.dart';
import 'commands/display.dart';
import 'commands/get_info.dart';

import 'commands/get_card.dart';

import 'commands/table_load_init.dart';
import 'commands/table_load_rec.dart';
import 'commands/table_load_end.dart';
import 'commands/get_timestamp.dart';

class RequestHandlerFactory
    with
        OpenFactory,
        CloseFactory,
        DisplayFactory,
        GetInfo00Factory,

        // Card Processing
        GetCardFactory,
        // ChangeParameterFactory,
        // GoOnChipFactory,

        // Table Maintenance
        TableLoadInitFactory,
        TableLoadRecFactory,
        TableLoadEndFactory,
        GetTimestampFactory
// -
{}

import 'commands/open.dart';
import 'commands/close.dart';

import 'commands/get_info.dart';
import 'commands/display.dart';
import 'commands/get_key.dart';

import 'commands/get_card.dart';

import 'commands/table_load_init.dart';
import 'commands/table_load_rec.dart';
import 'commands/table_load_end.dart';
import 'commands/get_timestamp.dart';

class RequestHandlerFactory
    with
        // Control
        OpenFactory,
        CloseFactory,

        // Basic
        GetInfo00Factory,
        DisplayFactory,
        GetKeyFactory,

        // Card Processing
        // GetCardFactory,
        // ChangeParameterFactory,
        // GoOnChipFactory,

        // Table Maintenance
        TableLoadInitFactory,
        TableLoadRecFactory,
        TableLoadEndFactory,
        GetTimestampFactory
// -
{}

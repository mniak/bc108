import 'package:bc108/src/layer3/commands/table_load_end.dart';

import 'commands/get_info.dart';
import 'commands/table_load_init.dart';
import 'commands/table_load_rec.dart';

class RequestHandlerFactory
    with
        GetInfo00Factory,
        TableLoadInitFactory,
        TableLoadRecFactory,
        TableLoadEndFactory {}

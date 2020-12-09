enum Status {
  PP_OK,
  PP_PROCESSING,
  PP_NOTIFY,
  PP_F1,
  PP_F2,
  PP_F3,
  PP_F4,
  PP_BACKSP,
  PP_INVCALL,
  PP_INVPARM,
  PP_TIMEOUT,
  PP_CANCEL,
  PP_ALREADYOPEN,
  PP_NOTOPEN,
  PP_EXECERR,
  PP_INVMODEL,
  PP_NOFUNC,
  PP_TABEXP,
  PP_TABERR,
  PP_NOAPPLIC,
  PP_PORTERR,
  PP_COMMERR,
  PP_UNKNOWNSTAT,
  PP_RSPERR,
  PP_COMMTOUT,
  PP_INTERR,
  PP_MCDATAERR,
  PP_ERRPIN,
  PP_NOCARD,
  PP_PINBUSY,
  PP_SAMERR,
  PP_NOSAM,
  PP_SAMINV,
  PP_DUMBCARD,
  PP_ERRCARD,
  PP_CARDINV,
  PP_CARDBLOCKED,
  PP_CARDNAUTH,
  PP_CARDEXPIRED,
  PP_CARDERRSTRUCT,
  PP_CARDPROBLEMS,
  PP_CARDINVDATA,
  PP_CARDAPPNAV,
  PP_CARDAPPNAUT,
  PP_NOBALANCE,
  PP_LIMITEXC,
  PP_CARDNOTEFFECT,
  PP_VCINVCURR,
  PP_ERRFALLBACK,
  PP_CTLSSMULTIPLE,
  PP_CTLSSCOMMERR,
  PP_CTLSSINVALIDAT,
  PP_CTLSSPROBLEMS,
  PP_CTLSSAPPNAV,
  PP_CTLSSAPPNAUT,
}

const Statuses = [
  Status.PP_OK,
  Status.PP_PROCESSING,
  Status.PP_NOTIFY,
  Status.PP_F1,
  Status.PP_F2,
  Status.PP_F3,
  Status.PP_F4,
  Status.PP_BACKSP,
  Status.PP_INVCALL,
  Status.PP_INVPARM,
  Status.PP_TIMEOUT,
  Status.PP_CANCEL,
  Status.PP_ALREADYOPEN,
  Status.PP_NOTOPEN,
  Status.PP_EXECERR,
  Status.PP_INVMODEL,
  Status.PP_NOFUNC,
  Status.PP_TABEXP,
  Status.PP_TABERR,
  Status.PP_NOAPPLIC,
  Status.PP_PORTERR,
  Status.PP_COMMERR,
  Status.PP_UNKNOWNSTAT,
  Status.PP_RSPERR,
  Status.PP_COMMTOUT,
  Status.PP_INTERR,
  Status.PP_MCDATAERR,
  Status.PP_ERRPIN,
  Status.PP_NOCARD,
  Status.PP_PINBUSY,
  Status.PP_SAMERR,
  Status.PP_NOSAM,
  Status.PP_SAMINV,
  Status.PP_DUMBCARD,
  Status.PP_ERRCARD,
  Status.PP_CARDINV,
  Status.PP_CARDBLOCKED,
  Status.PP_CARDNAUTH,
  Status.PP_CARDEXPIRED,
  Status.PP_CARDERRSTRUCT,
  Status.PP_CARDPROBLEMS,
  Status.PP_CARDINVDATA,
  Status.PP_CARDAPPNAV,
  Status.PP_CARDAPPNAUT,
  Status.PP_NOBALANCE,
  Status.PP_LIMITEXC,
  Status.PP_CARDNOTEFFECT,
  Status.PP_VCINVCURR,
  Status.PP_ERRFALLBACK,
  Status.PP_CTLSSMULTIPLE,
  Status.PP_CTLSSCOMMERR,
  Status.PP_CTLSSINVALIDAT,
  Status.PP_CTLSSPROBLEMS,
  Status.PP_CTLSSAPPNAV,
  Status.PP_CTLSSAPPNAUT,
];

extension IntToStatusConverter on int {
  Status toStatus() {
    switch (this) {
      case 0:
        return Status.PP_OK;
      case 1:
        return Status.PP_PROCESSING;
      case 2:
        return Status.PP_NOTIFY;
      case 4:
        return Status.PP_F1;
      case 5:
        return Status.PP_F2;
      case 6:
        return Status.PP_F3;
      case 7:
        return Status.PP_F4;
      case 8:
        return Status.PP_BACKSP;
      case 10:
        return Status.PP_INVCALL;
      case 11:
        return Status.PP_INVPARM;
      case 12:
        return Status.PP_TIMEOUT;
      case 13:
        return Status.PP_CANCEL;
      case 14:
        return Status.PP_ALREADYOPEN;
      case 15:
        return Status.PP_NOTOPEN;
      case 16:
        return Status.PP_EXECERR;
      case 17:
        return Status.PP_INVMODEL;
      case 18:
        return Status.PP_NOFUNC;
      case 20:
        return Status.PP_TABEXP;
      case 21:
        return Status.PP_TABERR;
      case 22:
        return Status.PP_NOAPPLIC;
      case 30:
        return Status.PP_PORTERR;
      case 31:
        return Status.PP_COMMERR;
      case 32:
        return Status.PP_UNKNOWNSTAT;
      case 33:
        return Status.PP_RSPERR;
      case 34:
        return Status.PP_COMMTOUT;
      case 40:
        return Status.PP_INTERR;
      case 41:
        return Status.PP_MCDATAERR;
      case 42:
        return Status.PP_ERRPIN;
      case 43:
        return Status.PP_NOCARD;
      case 44:
        return Status.PP_PINBUSY;
      case 50:
        return Status.PP_SAMERR;
      case 51:
        return Status.PP_NOSAM;
      case 52:
        return Status.PP_SAMINV;
      case 60:
        return Status.PP_DUMBCARD;
      case 61:
        return Status.PP_ERRCARD;
      case 62:
        return Status.PP_CARDINV;
      case 63:
        return Status.PP_CARDBLOCKED;
      case 64:
        return Status.PP_CARDNAUTH;
      case 65:
        return Status.PP_CARDEXPIRED;
      case 66:
        return Status.PP_CARDERRSTRUCT;
      case 68:
        return Status.PP_CARDPROBLEMS;
      case 69:
        return Status.PP_CARDINVDATA;
      case 70:
        return Status.PP_CARDAPPNAV;
      case 71:
        return Status.PP_CARDAPPNAUT;
      case 72:
        return Status.PP_NOBALANCE;
      case 73:
        return Status.PP_LIMITEXC;
      case 74:
        return Status.PP_CARDNOTEFFECT;
      case 75:
        return Status.PP_VCINVCURR;
      case 76:
        return Status.PP_ERRFALLBACK;
      case 80:
        return Status.PP_CTLSSMULTIPLE;
      case 81:
        return Status.PP_CTLSSCOMMERR;
      case 82:
        return Status.PP_CTLSSINVALIDAT;
      case 83:
        return Status.PP_CTLSSPROBLEMS;
      case 84:
        return Status.PP_CTLSSAPPNAV;
      case 85:
        return Status.PP_CTLSSAPPNAUT;
      default:
        return Status.PP_UNKNOWNSTAT;
    }
  }
}

extension StatusToIntConverter on Status {
  int toInt() {
    switch (this) {
      case Status.PP_OK:
        return 0;
      case Status.PP_PROCESSING:
        return 1;
      case Status.PP_NOTIFY:
        return 2;
      case Status.PP_F1:
        return 4;
      case Status.PP_F2:
        return 5;
      case Status.PP_F3:
        return 6;
      case Status.PP_F4:
        return 7;
      case Status.PP_BACKSP:
        return 8;
      case Status.PP_INVCALL:
        return 10;
      case Status.PP_INVPARM:
        return 11;
      case Status.PP_TIMEOUT:
        return 12;
      case Status.PP_CANCEL:
        return 13;
      case Status.PP_ALREADYOPEN:
        return 14;
      case Status.PP_NOTOPEN:
        return 15;
      case Status.PP_EXECERR:
        return 16;
      case Status.PP_INVMODEL:
        return 17;
      case Status.PP_NOFUNC:
        return 18;
      case Status.PP_TABEXP:
        return 20;
      case Status.PP_TABERR:
        return 21;
      case Status.PP_NOAPPLIC:
        return 22;
      case Status.PP_PORTERR:
        return 30;
      case Status.PP_COMMERR:
        return 31;
      case Status.PP_UNKNOWNSTAT:
        return 32;
      case Status.PP_RSPERR:
        return 33;
      case Status.PP_COMMTOUT:
        return 34;
      case Status.PP_INTERR:
        return 40;
      case Status.PP_MCDATAERR:
        return 41;
      case Status.PP_ERRPIN:
        return 42;
      case Status.PP_NOCARD:
        return 43;
      case Status.PP_PINBUSY:
        return 44;
      case Status.PP_SAMERR:
        return 50;
      case Status.PP_NOSAM:
        return 51;
      case Status.PP_SAMINV:
        return 52;
      case Status.PP_DUMBCARD:
        return 60;
      case Status.PP_ERRCARD:
        return 61;
      case Status.PP_CARDINV:
        return 62;
      case Status.PP_CARDBLOCKED:
        return 63;
      case Status.PP_CARDNAUTH:
        return 64;
      case Status.PP_CARDEXPIRED:
        return 65;
      case Status.PP_CARDERRSTRUCT:
        return 66;
      case Status.PP_CARDPROBLEMS:
        return 68;
      case Status.PP_CARDINVDATA:
        return 69;
      case Status.PP_CARDAPPNAV:
        return 70;
      case Status.PP_CARDAPPNAUT:
        return 71;
      case Status.PP_NOBALANCE:
        return 72;
      case Status.PP_LIMITEXC:
        return 73;
      case Status.PP_CARDNOTEFFECT:
        return 74;
      case Status.PP_VCINVCURR:
        return 75;
      case Status.PP_ERRFALLBACK:
        return 76;
      case Status.PP_CTLSSMULTIPLE:
        return 80;
      case Status.PP_CTLSSCOMMERR:
        return 81;
      case Status.PP_CTLSSINVALIDAT:
        return 82;
      case Status.PP_CTLSSPROBLEMS:
        return 83;
      case Status.PP_CTLSSAPPNAV:
        return 84;
      case Status.PP_CTLSSAPPNAUT:
        return 85;
      default:
        return 32; // unknown
    }
  }
}

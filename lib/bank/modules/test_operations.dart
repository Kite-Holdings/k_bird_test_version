import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:kite_bird/bank/configs/bank_config.dart';
import 'package:kite_bird/bank/modules/bank_modules.dart' show fetchCoopToken;
import 'package:kite_bird/kite_bird.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:http/http.dart' as http;

Future test(Map<String, dynamic> payload) async {
  print('test function..........');
  final String _accessToken = await fetchCoopToken();
  final Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
  };
  const bool trustSelfSigned = true;
  final HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  final IOClient ioClient = IOClient(httpClient);
  print("about to try....................");
  try{
    print("trying.................");
    final http.Response r = await ioClient.post(peaslinkUrl, headers: headers, body: json.encode(payload));
    print("done!!!!!!!!!!!!!!!!!");
    return r.body;
  } catch (e){
    print("error!!!!!!!!!!!!!!!!!!!!!");
    return e.toString();
  }

}

Future greaterThan() async {
  print("greaterthan fubction...................");
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 5000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 5000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);

}


Future lessThanThree() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 50,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 10,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      {
        "ReferenceNumber": '${messageReference}_2',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 10,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      {
        "ReferenceNumber": '${messageReference}_3',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 30,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      
    ]
  };
  return test(payload);

}


Future greaterThanThree() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 5000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      {
        "ReferenceNumber": '${messageReference}_2',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 3000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      {
        "ReferenceNumber": '${messageReference}_3',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      },
      
    ]
  };
  return test(payload);

}


Future lessThan() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 50,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 50,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);

}

Future notEqual() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 5000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 500,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}


Future zero() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 0,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 0,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}


Future invalidValues() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 'z',
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 'z',
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingValue() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": null,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 100,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 100,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingParameter() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    // "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 100,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 100,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}


Future diplicateMessageRef() async {
  const String messageReference = 'hgcfjfdfjbccxbccgccvc';
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 1000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingCurrency() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 1000,
      // "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        // "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingAmount() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      // "Amount": 1000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        // "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingBranchCode() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 1000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        // "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingDestination() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 1000,
      "TransactionCurrency": 'KES',
      "Narration": 'test operation'
    },
    // "Destinations": [
    //   {
    //     "ReferenceNumber": '${messageReference}_1',
    //     "AccountNumber": '01136163949600',
    //     // "BankCode": 11,
    //     "Amount": 1000,
    //     "TransactionCurrency": 'KES',
    //     "Narration": 'test operation'
    //   }
    // ]
  };
  return test(payload);
}

Future missingNaration() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    "Source": {
      "AccountNumber": '01136163949600',
      "Amount": 1000,
      "TransactionCurrency": 'KES',
      // "Narration": 'test operation'
    },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        // "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}

Future missingSource() async {
  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "CallBackUrl": 'http://18.189.117.13:8008/',
    // "Source": {
    //   "AccountNumber": '01136163949600',
    //   "Amount": 1000,
    //   "TransactionCurrency": 'KES',
    //   "Narration": 'test operation'
    // },
    "Destinations": [
      {
        "ReferenceNumber": '${messageReference}_1',
        "AccountNumber": '01136163949600',
        "BankCode": 11,
        "Amount": 1000,
        "TransactionCurrency": 'KES',
        "Narration": 'test operation'
      }
    ]
  };
  return test(payload);
}



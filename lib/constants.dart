import 'package:flutter_dotenv/flutter_dotenv.dart';
class Constants{
  static get appName => DotEnv().env['APP_NAME'];
  static get appFullName => DotEnv().env['APP_FULL_NAME'];
  static const String filter = 'Filter';
//  static const String Settings = 'Settings';
  static const String logout = 'Log out';
  static const String home = 'Home';
  static const String apartment = 'Apartment';
  static const String apartment_tower = 'Apartment Tower';
  static const String apartment_unit = 'Apartment Unit';
  static const String payment_schema = 'Payment Schema';
  static const String customer_identity = 'Customer Identity';
  static const String scan_document = 'Foto KTP / NPWP';
  static const String installment = 'Surat Pemesanan Sementara';
  static const String tos = 'Syarat dan Ketentuan';
  static const String signature_pad = 'Tanda Tangan';
  static const String success = 'Success';
  static const String order = 'Pemesanan';
  static const String order_detail = 'Detail Pemesanan';
  static const String customer = 'Customer';
  static const String customer_detail = 'Detail Customer';
  static const String customer_edit = 'Ubah Customer';
  static const String customer_lead = 'Calon Customer';
  static const String customer_lead_detail = 'Detail Calon Customer';
  static const String customer_lead_add = 'Tambah Calon Customer';
  static const String customer_lead_edit = 'Ubah Calon Customer';
  static const String events = 'Events';
  static const String event_detail = 'Detail Event';
  static const String event_detail_add = 'Tambah Detail Event';
  static const String map = 'Lokasi';
  static const String calculator = 'Kalkulator Loan';
  static const String profile = 'Profile';
  static const String edit_profile = 'Ubah Profile';
  static const String edit_password = 'Ubah Password';

  static const List<String> menu = <String>[
    filter,
    logout
  ];
  // static const List<String> fragments = <String>[
  //   home,
  //   apartment,
  //   apartment_tower,
  //   apartment_unit,
  //   order,
  //   customer,
  //   events,
  //   map,
  //   calculator,
  //   edit_profile,
  //   edit_password,
  //   logout,
  // ];
  // static Map<String, String> fragments = {
  //   'home': home,
  //   'apartment': apartment,
  //   'apartment_tower': apartment_tower,
  //   'apartment_unit': apartment_unit,
  //   'payment_schema': payment_schema,
  //   'customer_identity': customer_identity,
  //   'scan_document': scan_document,
  //   'installment': installment,
  //   'tos': tos,
  //   'signature_pad': signature_pad,
  //   'success': success,
  //   'order': order,
  //   'order_detail': order_detail,
  //   'customer': customer,
  //   'customer_detail': customer_detail,
  //   'customer_edit': customer_edit,
  //   'customer_lead': customer_lead,
  //   'customer_lead_detail': customer_lead_detail,
  //   'customer_lead_add': customer_lead_add,
  //   'customer_lead_edit': customer_lead_edit,
  //   'customer': customer,
  //   'events': events,
  //   'event_detail': event_detail,
  //   'event_detail_add': event_detail_add,
  //   'map': map,
  //   'calculator': calculator,
  //   'profile': profile,
  //   'edit_profile': edit_profile,
  //   'edit_password': edit_password,
  //   'logout': logout,
  // };
}
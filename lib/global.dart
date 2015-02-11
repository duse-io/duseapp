library duseapp.global;

import 'package:duse/duse.dart';
import 'package:restpoint/restpoint_client_client.dart';


class DuseClientConfig {
  const DuseClientConfig();
}

bool isEmpty(String string) {
  if (null == string || string.isEmpty) return true;
  return false;
}
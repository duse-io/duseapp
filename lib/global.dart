library duseapp.global;


class DuseClientConfig {
  const DuseClientConfig();
}

bool isEmpty(String string) {
  if (null == string || string.isEmpty) return true;
  return false;
}
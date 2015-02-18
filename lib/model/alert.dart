library duseapp.model.alert;

class Alert {
  static const _TYPE_SUCCESS = "success";
  static const _TYPE_WARNING = "warning";
  static const _TYPE_INFO = "info";
  static const _TYPE_DANGER = "danger";
  
  final String type;
  final String content;
  
  const Alert._(this.type, this.content);
  
  const Alert.success(String content) : this._(_TYPE_SUCCESS, content);
  
  const Alert.warning(String content) : this._(_TYPE_WARNING, content);
  
  const Alert.danger(String content) : this._(_TYPE_DANGER, content);
  
  const Alert.info(String content) : this._(_TYPE_INFO, content);
}
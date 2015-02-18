library duseapp.component.load_button;

import 'package:angular/angular.dart';

@Component(
    selector: 'load-button',
    template: '<button ng-disabled="isLoading" ng-class="buttonClass()">{{buttonText}}</button>',
    useShadowDom: false)
class LoadButtonComponent {
  static const String _DEFAULT_LOAD_TEXT = "Loading...";
  static const String _DEFAULT_SUBMIT_TEXT = "Submit";
  static const String _DEFAULT_TYPE = "default";
  static const bool _DEFAULT_IS_LOADING = false;
  static const bool _DEFAULT_BLOCK = false;
  
  bool _isLoading = _DEFAULT_IS_LOADING;
  String _loadText = _DEFAULT_LOAD_TEXT;
  String _submitText = _DEFAULT_SUBMIT_TEXT;
  String _type = _DEFAULT_TYPE;
  bool _block = _DEFAULT_BLOCK;
  
  @NgAttr("is-loading")
  void set isLoading(value) {
    _isLoading = null == value ? _DEFAULT_IS_LOADING : true;
  }
  
  bool get isLoading => _isLoading;
  
  @NgAttr("block")
  void set block(String value) {
    _block = null == value ? _DEFAULT_BLOCK : true; 
  }
  
  @NgAttr("load-text")
  void set loadText(String text) {
    _loadText = _default(text, _DEFAULT_LOAD_TEXT);
  }
  
  @NgAttr("submit-text")
  void set submitText(String text) {
    _submitText = _default(text, _DEFAULT_SUBMIT_TEXT);
  }
  
  @NgAttr("type")
  void set type(String type) {
    _type = _default(type, _DEFAULT_TYPE);
  }
  
  bool get _isBlock => null == _block ? _DEFAULT_BLOCK : _block;
  
  String buttonClass() => "btn btn-$_type" + (_isBlock ? " btn-block" : "");
  
  _default(value, defaultValue) => null == value ? defaultValue : value;
  
  String get buttonText => _isLoading ? _loadText : _submitText;
}
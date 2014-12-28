import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:html_components/html_components.dart' show DatatableComponent, GrowlComponent;
import 'data/event.dart' as data;


@CustomTag('datatable-edit-demo')
class DatatableEditDemo extends PolymerElement {


  var _selectedItem;

  @observable List<data.Event> events;

  // = [new data.Event("111","222","333")]; // = toObservable(data.events);

  DatatableEditDemo.created() : super.created();

//  {
//    events = new List();
//    events.add(new data.Event("aaa","bbb","ccc"));
//  }

  void onItemEdited(Event event, var detail, DatatableComponent target) {
    GrowlComponent.postMessage('', 'Item edited!');
  }

  void onItemSelected(Event event, var detail, DatatableComponent target) {
    if (target.selectedItems.isEmpty)
        _selectedItem=null;
     else
    _selectedItem = target.selectedItems.first;
//    GrowlComponent.postMessage('Selected items:', _selectedItem.toString());
  }

  void openEvent(Event event, var detail, var target) {
    if (_selectedItem == null)
      GrowlComponent.postMessage('Select event to open', "");
    else
      GrowlComponent.postMessage('Open event ', _selectedItem.toString());
  }

  void addEvent(Event event, var detail, var target) {
    GrowlComponent.postMessage('', 'Add new event pressed');
  }


  List<data.Event> getEvents() {
    return [
        new data.Event("Boston marathon1", "Boston", "---"),
        new data.Event("Boston marathon2", "Boston", "---"),
    ];
  }
}


main() => initPolymer();

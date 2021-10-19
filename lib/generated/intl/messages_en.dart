// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Alert_Delete": MessageLookupByLibrary.simpleMessage("DELETE"),
        "Alert_Error": MessageLookupByLibrary.simpleMessage("ERROR"),
        "Alert_Finish": MessageLookupByLibrary.simpleMessage("FINISH"),
        "Alert_Remind": MessageLookupByLibrary.simpleMessage("Remind"),
        "Alert_Warning": MessageLookupByLibrary.simpleMessage("WARNING"),
        "Button_Cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "Button_Confirm": MessageLookupByLibrary.simpleMessage("Sure"),
        "add_member_hint":
            MessageLookupByLibrary.simpleMessage("Please type in member name"),
        "existed_beverage":
            MessageLookupByLibrary.simpleMessage("Beverage is existed"),
        "existed_mainDish":
            MessageLookupByLibrary.simpleMessage("MainDish is existed"),
        "existed_member":
            MessageLookupByLibrary.simpleMessage("Member is existed"),
        "hint_sort":
            MessageLookupByLibrary.simpleMessage("Sort (smaller first)")
      };
}

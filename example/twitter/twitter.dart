// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// A JS interop sample showing JSONP access to Twitter from Dart.

#import('dart:html');
#import('dart:json');
// TODO(vsm): Make this a package path.
#import('../../lib/js.dart', prefix: 'js');

void main() {
  js.scoped(() {
    // Create a JavaScript function called display that forwards to the Dart
    // function.
    js.context.display = new js.Callback.once1(display);

    // Inject a JSONP request to Twitter invoking the JavaScript display
    // function.
    document.body.nodes.add(new ScriptElement()..src =
        "https://search.twitter.com/search.json?q=dartlang&rpp=20&callback=display");
  });
}

// Convert URLs in the text to links.
String linkify(String text) {
  List words = text.split(' ');
  var buffer = new StringBuffer();
  for (var word in words) {
    if (!buffer.isEmpty()) buffer.add(' ');
    if (word.startsWith('http://') || word.startsWith('https://')) {
      buffer.add('<a href="$word">$word</a>');
    } else {
      buffer.add(word);
    }
  }
  return buffer.toString();
}

// Display the JSON data on the web page.
// Note callbacks are automatically executed within a scope.
void display(var data) {
  var results = data.results;
  // The data and results objects are proxies to JavaScript object,
  // so we cannot iterate directly on them.
  for (var i = 0; i < results.length; ++i) {
    var result = results[i];
    var user = result.from_user_name;
    var time = result.created_at;
    var text = linkify(result.text);
    var div = new DivElement();
    div.innerHTML = '<div>From: $user</div><div>$text</div><p>';
    document.body.nodes.add(div);
  }
}

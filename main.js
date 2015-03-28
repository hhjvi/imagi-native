(function () {
  'use strict';
  var storage = {passports: [], entries: []};
  function init_storage() {
    // Retrieve all data.
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'file:///home/lsq/develop/hhjvi/imagi-native/server/memory.txt', false);
    xhr.send();
    // Split the data.
    var lines = xhr.responseText.split('\n'), line = '';
    for (var i = 0; i < lines.length; i++) {
      var words = lines[i].split(' '), date = words[0].split('-'), operation = words[1];
      var date_str = date[0] + '-' + date[1] + '-' + date[2] + ' ' + date[3] + ':' + date[4] + ':' + date[5];
      if (operation === 'newcomer') {
        storage.passports.push({name: words[2], passport: words.slice(3).join(' ')});
      } else if (operation === 'entry') {
        storage.entries.push({title: words[3], author: parseInt(words[2]), comments: []});
      } else if (operation === 'retitle') {
        storage.entries[parseInt(words[3])].title = words.slice(4).join(' ');
      } else if (operation === 'comment') {
        storage.entries[parseInt(words[3])].comments.push({author: parseInt(words[2]), text: words.slice(4).join(' ')});
      }
    }
    console.log(storage);
  }
  init_storage();
}());

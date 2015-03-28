(function () {
  'use strict';
  window.storage = {passports: [], entries: []};
  window.templates = {};
  window.logged_in_as = -1;
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
        window.storage.passports.push({name: words[2], passport: words.slice(3).join(' ')});
      } else if (operation === 'entry') {
        window.storage.entries.push({date: date_str, title: words.slice(3).join(' '), author: parseInt(words[2]), comments: []});
      } else if (operation === 'retitle') {
        window.storage.entries[parseInt(words[3])].title = words.slice(4).join(' ');
      } else if (operation === 'comment') {
        window.storage.entries[parseInt(words[3])].comments.push({date: date_str, author: parseInt(words[2]), text: words.slice(4).join(' ')});
      }
    }
  }

  function init_templates() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'file:///home/lsq/develop/hhjvi/imagi-native/templates.tpl', false);
    xhr.send();
    // Split the templates.            vv These slashes are escaped
    var tpls = xhr.responseText.split('\\\\(QwQ)\n');
    for (var i = 0; i < tpls.length; i++) {
      var content_pos = tpls[i].indexOf('\n'), script_pos = tpls[i].indexOf('(=~=)|||\n');
      window.templates[tpls[i].substr(0, content_pos)] = {
        html: tpls[i].substr(content_pos + 1, script_pos - content_pos - 1),
        script: new Function(tpls[i].substr(script_pos + '(=~=)|||\n'.length))
      };
    }
  }

  init_storage();
  init_templates();

  // http://segmentfault.com/blog/news/1190000000394948
  // Call with ('aaa(% for (i = 0; i < this.a.length; i++) { %)(% this.a[i] %)x(% } %) nn', {a: [4, 'aa', 6]})
  // Should be 'aaa4xaax6x nn'
  function templater(html, options) {
    var re = /\(%([^%>]+)?%\)/g, regex = /(^( )?(if|for|else|switch|case|break|{|}))(.*)?/g, code = 'var r=[];\n', cursor = 0, match;
    function add(line, js) {
      js ? (code += line.match(regex) ? line + '\n' : 'r.push(' + line + ');\n') :
        (code += line != '' ? 'r.push("' + line.replace(/"/g, '\\"') + '");\n' : '');
      return add;
    };
    while (match = re.exec(html)) {
      add(html.slice(cursor, match.index))(match[1], true);
      cursor = match.index + match[0].length;
    }
    add(html.substr(cursor, html.length - cursor));
    code += 'return r.join("");';
    return new Function(code.replace(/[\r\t\n]/g, '')).apply(options);
  }
  function render_template(name, options) {
    var t = window.templates[name];
    document.getElementById('template-area').innerHTML = templater(t.html, options);
    t.script();
  }
  window.render_template = render_template;

  render_template('LOGIN');
}());

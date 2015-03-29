(function () {
  'use strict';
  window.storage = {passports: [], entries: [], tags: [], namelist: []};
  window.templates = {};
  window.logged_in_as = -1;
  window.server = 'http://localhost:8715/imagi.php';
  window.storage_server = 'http://localhost:8715/memory.php';

  function init_storage() {
    // Retrieve the name list.
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'colours.txt', false);
    xhr.send();
    var lines = xhr.responseText.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var spc_pos = lines[i].indexOf(' ');
      window.storage.namelist[lines[i].substr(spc_pos + 1)] = {colour: lines[i].substr(0, spc_pos), used: false};
    }
    // Retrieve all other data.
    xhr = new XMLHttpRequest();
    xhr.open('GET', window.storage_server, false);
    xhr.send();
    // Split the data.
    lines = xhr.responseText.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var words = lines[i].split(' '), date = words[0].split('-'), operation = words[1];
      var date_str = date[0] + '-' + date[1] + '-' + date[2] + ' ' + date[3] + ':' + date[4] + ':' + date[5];
      if (operation === 'newcomer') {
        window.storage.passports.push({name: words[2], passport: words.slice(3).join(' ')});
        window.storage.namelist[words[2]].used = true;
      } else if (operation === 'entry') {
        window.storage.entries.push({date: date_str, title: words.slice(3).join(' '), author: parseInt(words[2]), tags: [], comments: []});
      } else if (operation === 'retitle') {
        window.storage.entries[parseInt(words[3])].title = words.slice(4).join(' ');
      } else if (operation === 'tag') {
        var tag = words.slice(4).join(' '), entryid = parseInt(words[3]);
        window.storage.tags[tag] = window.storage.tags[tag] || [];
        window.storage.tags[tag].push(entryid);
        window.storage.entries[entryid].tags.push(tag);
      } else if (operation === 'comment') {
        window.storage.entries[parseInt(words[3])].comments.push({date: date_str, author: parseInt(words[2]), text: words.slice(4).join(' ')});
      }
    }
    // Calculate the available name list.
    var avail_list = [];
    for (var n in window.storage.namelist) if (n !== '' && !window.storage.namelist[n].used) {
      avail_list.push(n);
    }
    window.storage.namelist.avail_list = avail_list;
  }

  function init_templates() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'templates.tpl', false);
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

  window.name_disp = function (id) {
    if (id == null) id = window.logged_in_as;   // id could be zero
    var myname = window.storage.passports[id].name;
    return "<span class='username' style='color: #" + window.storage.namelist[myname].colour + "'>" + myname + "</span>";
  };

  function hex_2dig(num) {
    return num < 16 ? ('0' + num.toString(16)) : num.toString(16);
  }
  window.tag_disp = function (tag) {
    var sum = 0;
    for (var i in tag) sum += tag.charCodeAt(i) * (i + 3);
    var ran1 = (tag.length * 103748 + sum * 33) % 256, ran2 = (tag.length * 6 + tag.charCodeAt(0) * 99 - sum) % 255, ran3 = Math.floor(tag.length / 1.18 - tag.charCodeAt(tag.length - 1) * 7.1 + sum * 99.122) % 256;
    var colour = '#' + hex_2dig(ran1) + hex_2dig(ran2) + hex_2dig(ran3);
    return "<span class='entry-tag" + (0.213 * ran1 + 0.715 * ran2 + 0.072 * ran3 > 127 ? "" : " inverse") + "' style='background: " + colour + "'>" + tag + "</span>";
  };

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

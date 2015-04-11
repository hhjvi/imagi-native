LOGIN
<div class='content-title'>Log In</div>
<div class='contents'>
  <input id='login-passport' class='in-input' type='text' placeholder='Your passport'>
  <button id='login-button' class='pure-button in-button'>Start</button>
  <div id='login-warning'>
    通行证不正确，请检查 TwT
  </div>
  <br><br>关于注册：选择一些字母或者数字作为你的登录通行证，在前面加上“-”（例如“-MyPassport”），走起～
</div>

<style>
  #login-passport {
    margin-top: 2em;
  }

  #login-button {
    margin-top: 1em;
    width: 100%;
  }

  #login-warning {
    margin: 1em auto;
    padding: 0.6em;
    border: 1px solid #f44;
    border-radius: 4px;
    background: #fcc;
    display: none;
  }
  #login-warning.force-display {
    display: block;
  }
</style>

(=~=)|||
//<script>
var login_button_click = function () {
  var pp = document.getElementById('login-passport').value;
  if (pp.substr(0, 1) === '-') {
    pp = pp.substr(1);
    var name = window.storage.namelist.avail_list[Math.floor(Math.random() * window.storage.namelist.avail_list.length)];
    var xhr = new XMLHttpRequest();
    xhr.open('GET', window.server + '?operation=newcomer&arg1=' + name + '&arg2=' + encodeURI(pp));
    xhr.send();
    // Update the local data
    window.logged_in_as = window.storage.passports.push({name: name, passport: pp}) - 1;
    window.render_template('WELCOME');
    return;
  }
  for (var i = 0; i < window.storage.passports.length; i++)
    if (pp === window.storage.passports[i].passport) {
      window.logged_in_as = i; break;
    }
  if (window.logged_in_as >= 0) {
    window.render_template('LISTPAGE');
    xhr = new XMLHttpRequest();
    xhr.open('GET', window.server + '?operation=login&arg1=' + window.logged_in_as);
    xhr.send();
  }
  else document.getElementById('login-warning').classList.add('force-display');
};
document.getElementById('login-button').onclick = login_button_click;
document.getElementById('login-passport').onkeypress = function (e) {
  if (e.keyCode === 13) login_button_click();
};
//</script>

\\(QwQ)
LISTPAGE
<div class='pure-g'>
  <div id='passport-disp' class='pure-u-1-2'>Logged in as (% window.name_disp() %)</div>
  <div class='pure-u-1-2 right-align'><a class='pure-button pure-button-primary' href='javascript:window.render_template("NEWENTRY");'>+ New entry</a></div>
</div>
<div id='entry-list'>
  (% for (var i = 0; i < window.storage.entries.length; i++) { %)
    <hr>
    (% window.entry_disp(i) %)
  (% } %)
</div>

<style>
  #passport-disp {
    font-size: 28px;
  }

  #entry-list {
    font-size: 28px;
    padding: 0 1em;
    margin-top: 1em;
  }
</style>

(=~=)|||
//<script>
window.show_entry = function (idx) {
  window.render_template('ENTRYPAGE', {index: idx});
}
//</script>

\\(QwQ)
ENTRYPAGE
<div id='passport-disp'>Logged in as (% window.name_disp() %)</div>
<a id='back-button' class='pure-button' href='javascript:window.render_template("LISTPAGE");'>&nbsp;&lt; Back</a>
(% (cur_entry = window.storage.entries[this.index], '') %)
(% (window.entry_index = this.index, '') %)
<div id='entry-solo-title'>(% cur_entry.title %)</div>
<span class='timestamp'>Created by (% window.name_disp(cur_entry.author) %) at (% cur_entry.date %)</span>
<div class='entry-taglist'>
  (% for (var i in cur_entry.tags) { %)
    (% window.tag_disp(cur_entry.tags[i]) %)
  (% } %)
  <a id='tag-add-button' class='pure-button' href='javascript:;'>+</a>
</div>
<div id='comments-list'>
  (% for (var i = 0; i < cur_entry.comments.length; i++) { %)
    <hr>
    (% (cur_comment = cur_entry.comments[i], '') %)
    <p>(% cur_comment.text %)</p>
    <p class='timestamp right-align'>... Says (% window.name_disp(cur_comment.author) %) at (% cur_comment.date %)</p>
  (% } %)
</div>

<div id='comments-post'>
  <textarea id='comment-text' rows='4'></textarea>
  <button id='comment-button' class='pure-button pure-button-primary'>+ Post comment</button>
</div>

<style>
  #passport-disp {
    font-size: 28px;
  }

  #entry-solo-title {
    margin-top: 0.8em;
    font-size: 44px;
    font-weight: bold;
  }

  .timestamp {
    font-size: 28px;
  }

  #tag-add-button {
    padding: 0px 0.5em;
  }

  #comments-list {
    margin-top: 0.8em;
    font-size: 32px;
  }

  #comment-text {
    font-size: 28px;
    border: 1px solid black;
    border-radius: 3px;
    width: 100%;
    resize: vertical;
    margin-bottom: 1em;
  }

  #comment-button {
    margin-bottom: 1em;
  }
</style>

(=~=)|||
//<script>
// 我真的火星了……现在才知道JavaScript里有个prompt() T^T
// http://bbs.csdn.net/topics/20346546
document.getElementById('tag-add-button').onclick = function () {
  var newtag = prompt("New tag's title:"), valid = true;
  if (!newtag) return;
  for (i in window.storage.entries[window.entry_index].tags)
    if (window.storage.entries[window.entry_index].tags[i] === newtag) {
      // 立flag？？？
      valid = false; break;
    }
  if (valid) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', window.server + '?operation=tag&arg1=' + window.logged_in_as + '&arg2=' + window.entry_index + '&arg3=' + encodeURI(newtag));
    xhr.send();
    window.storage.entries[window.entry_index].tags.push(newtag);
    window.storage.tags[newtag] = window.storage.tags[newtag] || [];
    window.storage.tags[newtag].push(window.entry_index);
    window.render_template('ENTRYPAGE', {index: window.entry_index});
  } else {
    alert('Tag (' + newtag + ') already added ==');
  }
};

document.getElementById('comment-button').onclick = function () {
  var text = document.getElementById('comment-text').value.replace(/\n/g, '<br>').replace(/&/g, '&amp;');
  var xhr = new XMLHttpRequest();
  xhr.open('GET', window.server + '?operation=comment&arg1=' + window.logged_in_as + '&arg2=' + window.entry_index + '&arg3=' + encodeURI(text).replace(/&/g, '%26').replace(/#/g, '%23'));
  xhr.send();
  // Get the time
  var d = new Date(), time_str = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() + ' ' + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds();
  window.storage.entries[window.entry_index].comments.push({date: time_str, author: window.logged_in_as, text: text});
  window.render_template('ENTRYPAGE', {index: window.entry_index});
};

var xhr = new XMLHttpRequest();
xhr.open('GET', window.server + '?operation=pageview&arg1=' + window.logged_in_as + '&arg2=' + window.entry_index);
xhr.send();
//</script>

\\(QwQ)
NEWENTRY
<div id='passport-disp'>Logged in as (% window.name_disp() %)</div><br>

<div class='content-title'>Create Entry</div>
<div class='contents'>
  <input id='newentry-title' class='in-input' type='text' placeholder='Title'>
  <button id='newentry-button' class='pure-button in-button'>+ Add</button>
</div>

<style>
  #passport-disp {
    font-size: 28px;
  }

  #newentry-title {
    margin-top: 2em;
  }

  #newentry-button {
    margin-top: 1em;
    width: 100%;
  }
</style>

(=~=)|||
//<script>
var newentry_button_click = function () {
  var title = document.getElementById('newentry-title').value;
  var xhr = new XMLHttpRequest();
  xhr.open('GET', window.server + '?operation=entry&arg1=' + window.logged_in_as + '&arg2=' + encodeURI(title));
  xhr.send();
  // Update the local data
  var d = new Date(), time_str = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() + ' ' + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds();
  window.storage.entries.push({date: time_str, author: window.logged_in_as, title: title, tags: [], comments: []});
  window.render_template('LISTPAGE');
};
document.getElementById('newentry-button').onclick = newentry_button_click;
document.getElementById('newentry-title').onkeypress = function (e) {
  if (e.keyCode === 13) newentry_button_click();
};
//</script>

\\(QwQ)
TAGPAGE
<div id='passport-disp'>Logged in as (% window.name_disp() %)</div>
<a id='back-button' class='pure-button' href='javascript:window.render_template("LISTPAGE");'>&nbsp;&lt; Back</a>
<br><br>
<div class='content-title'>Tag: (% window.tag_disp(this.tag) %)</div>
<div id='entry-list'>
  (% for (var i = 0; i < window.storage.tags[this.tag].length; i++) { %)
    (% window.entry_disp(window.storage.tags[this.tag][i]) %)
    <hr>
  (% } %)
</div>

<style>
  #passport-disp {
    font-size: 28px;
  }

  #entry-list {
    font-size: 28px;
    padding: 0 1em;
    margin-top: 1em;
  }
</style>

(=~=)|||

\\(QwQ)
WELCOME
<div id='passport-disp'>Logged in as (% window.name_disp() %)</div>

<div class='content-title'>Warmly welcome (% window.name_disp() %)</div>
<div class='contents'>
  <h1>== 寻找六班意象 ==</h1>
  <p>这是一个计划中的项目。如果参与人数足够，会考虑继续。</p>
  <p>对于毕业我不想说什么了……开门见山切入主题：把对本班影响最大的东东收集起来（说不定还可以做个视频，且 P(A)>0.9）。下面是我的想法。</p>
  <ul>
    <li>第一阶段：收集阶段（即日起～5月末）：所有无聊的童鞋（比如……ZY）把各种无聊的东东写到这里来。</li>
    <li>第二阶段：投票阶段（5月末～6月初）：所有无聊的童鞋（比如……ZY）给各种无聊的东东评分（评分项目可以有多个，例如，影响力、持久度<del>，“你好的”持久度超高</del>……）。</li>
    <li>第三阶段：处理阶段（6月初～？？）：收集数据，得到排行榜，然后视频</li>
  </ul>
  <hr>
  <h2>细节</h2>
  <p>没有“用户”的概念，而是使用匿名的通行证（passport），一个通行证对应一个随机分配的名字（都是颜色名），把通行证当密码使可以了。</p>
  <p>在这里有一个东东叫做“条目（entry）”……看过度娘百科的都知道，不解释。</p>
  <p>每个条目可以有一些标签（tag），不解释</p>
  <p>对于一个条目有任何补充或者想法或者只是想水一发，都可以发表评论。把评论区当弹幕就可以了。</p>
  <p>基本上就是这样，有意见和建议全部可以在“ADMIN”条目发评论。</p>
  <p>PS 有时候不想切输入法……然后开发的时候里面有一些英文……相信大家的英语水平。</p>
  <a id='letsgo-button' class='pure-button pure-button-primary' href='javascript:window.render_template("LISTPAGE")'>LET'S GO!!</a>
</div>

<style>
  #letsgo-button {
    width: 100%;
    font-size: 32px;
  }
</style>

(=~=)|||

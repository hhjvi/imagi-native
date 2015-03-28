LOGIN
<div class='content-title'>Log In</div>
<div class='contents'>
  <input id='login-passport' type='text' placeholder='Your passport'>
  <button id='login-button' class='pure-button in-button'>Start</button>
  <div id='login-warning'>
    通行证不正确，请检查 TwT
  </div>
  <br><br>第一次来？直接输入一些字母或者数字作为登录通行证。登录后将会进行更详细的解释。
</div>

<style>
  #login-passport {
    margin-top: 2em;
    font-size: 36px;
    width: 100%;
    border: 0px;
    border-bottom: 1px solid #ccc;
    padding-bottom: 1px;
  }

  #login-passport:focus {
    border-bottom: 2px solid #fc9;
    padding-bottom: 0px;
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
  for (var i = 0; i < window.storage.passports.length; i++)
    if (pp === window.storage.passports[i].passport) {
      window.logged_in_as = i; break;
    }
  if (window.logged_in_as >= 0) window.render_template('LISTPAGE');
  else document.getElementById('login-warning').classList.add('force-display');
};
document.getElementById('login-button').onclick = login_button_click;
document.getElementById('login-passport').onkeypress = function (e) {
  if (e.keyCode === 13) login_button_click();
};
//</script>

\\(QwQ)
LISTPAGE
(% (logged_p = window.storage.passports[window.logged_in_as], '') %)
<div id='passport-disp'>Logged in as <strong>(% logged_p.name %)</strong></div>
<div id='entry-list'>
  (% for (var i = 0; i < window.storage.entries.length; i++) { %)
    <hr>
    (% (cur_entry = window.storage.entries[i], '') %)
    <a class='entry-title' href='javascript:window.show_entry((% i %));'>(% cur_entry.title %)</a>
    <p class='timestamp'>Created by <strong>(% window.storage.passports[cur_entry.author].name %)</strong> at (% cur_entry.date %)</p>
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

  .entry-title {
    font-size: 1.5em;
  }

  .timestamp {
    color: #999;
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
(% (logged_p = window.storage.passports[window.logged_in_as], '') %)
<div id='passport-disp'>Logged in as <strong>(% logged_p.name %)</strong></div>
<a id='back-button' class='pure-button' href='javascript:window.render_template("LISTPAGE");'>&nbsp;&lt; Back</a>
(% (cur_entry = window.storage.entries[this.index], '') %)
<div id='entry-solo-title'>(% cur_entry.title %)</div>
<span class='timestamp'>Created by <strong>(% window.storage.passports[cur_entry.author].name %)</strong> at (% cur_entry.date %)</span>
<div id='comments-list'>
  (% for (var i = 0; i < cur_entry.comments.length; i++) { %)
    <hr>
    (% (cur_comment = cur_entry.comments[i], '') %)
    <p>(% cur_comment.text %)</p>
    <p class='timestamp right-align'>... Says <strong>(% window.storage.passports[cur_comment.author].name %)</strong> at (% cur_comment.date %)</p>
  (% } %)
</div>

<style>
  #passport-disp {
    font-size: 28px;
  }

  #back-button {
    border-top-left-radius: 30px;
    border-bottom-left-radius: 30px;
  }

  #entry-solo-title {
    margin-top: 0.8em;
    font-size: 44px;
    font-weight: bold;
  }

  .timestamp {
    font-size: 28px;
    color: #999;
  }

  #comments-list {
    margin-top: 0.8em;
    font-size: 32px;
  }
</style>

(=~=)|||

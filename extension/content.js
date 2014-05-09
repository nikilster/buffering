var SERVER_URL = 'http://localhost:8080';
var PUSHUP_CLEAR_THRESHOLD = 10;

document.documentElement.style.height = '100%';
document.body.style.height = '100%';
document.documentElement.style.width = '100%';
document.body.style.width = '100%';

// Set up blocking and text divs
var div = document.createElement('div');
var textDiv = document.createElement('div');
var textBackground = document.createElement('div');
document.body.appendChild(div);
div.appendChild(textDiv);

// Set attributes for blocking div
var img = document.createElement("img");
div.style.background="black";
div.id = 'bufferDiv';
div.style.position = 'fixed';
div.style.top = '0%';
div.style.left = '0%';
div.style.width = '100%';
div.style.height = '100%';
div.style.zIndex="2147483645";
// TODO: host this in the app instead of hotlinking to another domain
div.style.backgroundImage="url(http://hdwallpapersrc.com/wp-content/uploads/2014/03/wallpapers-motivation-arnold-schwarzenegger-bodybuilding-posters-celebrities-photo-arnold-schwarzenegger-hd-wallpaper.jpg)";
div.style.backgroundSize="100% 100%";

// Set attributes for text div
var text = get_unlock_string(0);
textDiv.id = 'textDiv';
textDiv.style.position = 'fixed';
textDiv.style.top = '25%';
textDiv.style.left = '50%';
textDiv.innerHTML=text;
textDiv.style.zIndex="2147483647";
textDiv.style.color="black";

// Listen to server for pushups
var num_pushups = 0;
var socket = io.connect(SERVER_URL);
socket.on('pushup', function (data) {
  if (num_pushups < PUSHUP_CLEAR_THRESHOLD) {
    num_pushups++;
    textDiv.innerHTML=get_unlock_string(num_pushups);
    if (num_pushups >= PUSHUP_CLEAR_THRESHOLD) {
      div.remove();
    }
  }
});

function get_unlock_string(num_pushups) {
  var pushups_remaining = PUSHUP_CLEAR_THRESHOLD - num_pushups;
  var pushups_str = pushups_remaining == 1 ? ' pushup' : ' pushups';
  return (pushups_remaining + pushups_str + ' to unlock').fontsize(24);
}

document.documentElement.style.height = '100%';
document.body.style.height = '100%';
document.documentElement.style.width = '100%';
document.body.style.width = '100%';

var div = document.createElement('div');
var textDiv = document.createElement('div');

//append all elements
document.body.appendChild( div );
div.appendChild(textDiv);
//set attributes for div
div.id = 'bufferDiv';
div.style.position = 'fixed';
div.style.top = '0%';
div.style.left = '0%';
div.style.width = '100%';
div.style.height = '100%';
div.style.zIndex="2147483646";
div.style.background="black"

textDiv.style.top = '50%';
textDiv.style.left = '50%';
textDiv.style.width = '100%';
textDiv.style.height = '100%';
textDiv.innerHTML="Hello, World!";
textDiv.style.zIndex="2147483647";
textDiv.style.color="white";

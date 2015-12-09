var script = document.createElement( 'script' );
script.src = "https://www.youtube.com/iframe_api";
var firstScript = document.getElementsByTagName( 'script' )[ 0 ];
firstScript.parentNode.insertBefore( script , firstScript );

var player, iframe;

// init player
function onYouTubeIframeAPIReady() {
  player = new YT.Player('movie', {
    videoId: 'WEtiK86GSAA',
    playerVars: {'showinfo': 0, 'autohide': 1, 'rel': 0, 'loop': 1, 'hd': 1, 'fs': 0},
    events: {
      'onReady': onPlayerReady
    }
  });
}

// when ready, wait for clicks
function onPlayerReady(event) {
  var player = event.target;
  iframe = $('#movie')[0];
  setupListener(); 
}

function setupListener (){
  player.addEventListener( 'onStateChange', playFullscreen );
}

function playFullscreen (){
  if(player.getPlayerState() != 2){
    var requestFullScreen = iframe.requestFullScreen || iframe.mozRequestFullScreen || iframe.webkitRequestFullScreen;
    if (requestFullScreen) {
      requestFullScreen.bind(iframe)();
    }
  }
}

document.addEventListener("webkitfullscreenchange", handleFSevent, false);
document.addEventListener("mozfullscreenchange", handleFSevent, false);
document.addEventListener("MSFullscreenChange", handleFSevent, false);
document.addEventListener("fullscreenchange", handleFSevent, false);
function handleFSevent() {
	if( (document.webkitFullscreenElement && document.webkitFullscreenElement !== null)
	 || (document.mozFullScreenElement && document.mozFullScreenElement !== null)
	 || (document.msFullscreenElement && document.msFullscreenElement !== null)
	 || (document.fullScreenElement && document.fullScreenElement !== null) ) {
		
	}else{
		location.reload();
	}
}


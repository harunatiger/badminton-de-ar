var script = document.createElement( 'script' );
script.src = "https://www.youtube.com/iframe_api";
var firstScript = document.getElementsByTagName( 'script' )[ 0 ];
firstScript.parentNode.insertBefore( script , firstScript );
var player, iframe;

/*play = document.getElementById('play');*/
$('#play').on('click',function(){
  if(player === undefined){
    new_player = true;
    player = new YT.Player('movie', {
      videoId: 'WEtiK86GSAA',
      playerVars: {'showinfo': 0, 'autohide': 1, 'rel': 0, 'loop': 1, 'hd': 1, 'fs': 1, 'autoplay': 1}
    })
  }
  playFullscreen ();
})

function playFullscreen (){
  iframe = $('#movie')[0];
  var requestFullScreen = iframe.requestFullScreen || iframe.mozRequestFullScreen || iframe.webkitRequestFullScreen;
  if (requestFullScreen) {
    requestFullScreen.bind(iframe)();
  }
  player.playVideo();
}

/*document.addEventListener("webkitfullscreenchange", handleFSevent, false);
document.addEventListener("mozfullscreenchange", handleFSevent, false);
document.addEventListener("MSFullscreenChange", handleFSevent, false);
document.addEventListener("fullscreenchange", handleFSevent, false);
function handleFSevent() {
	if( (document.webkitFullscreenElement && document.webkitFullscreenElement !== null)
	 || (document.mozFullScreenElement && document.mozFullScreenElement !== null)
	 || (document.msFullscreenElement && document.msFullscreenElement !== null)
	 || (document.fullScreenElement && document.fullScreenElement !== null) ) {
		
	}else{
	}
}*/


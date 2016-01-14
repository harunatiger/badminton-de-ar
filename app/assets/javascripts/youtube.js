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
      videoId: 'fhwj6m2cgEY',
      playerVars: {'showinfo': 0, 'autohide': 1, 'rel': 0, 'loop': 1, 'hd': 1, 'fs': 0, 'autoplay': 1},
      events: {onStateChange: onPlayerStateChange}
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

function onPlayerStateChange (){
  if (player.getPlayerState() == 2){
    if (document.webkitCancelFullScreen) {
      document.webkitCancelFullScreen();
    } else if (document.mozCancelFullScreen) {
      document.mozCancelFullScreen();
    } else if (document.msExitFullscreen) {
      document.msExitFullscreen();
    } else if(document.cancelFullScreen) {
      document.cancelFullScreen();
    } else if(document.exitFullscreen) {
      document.exitFullscreen();
    }
  }
}
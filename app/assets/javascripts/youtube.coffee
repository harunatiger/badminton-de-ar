# youtube.coffee

#$('').on 'click', ->
$('#play').magnificPopup
  type: 'iframe'
  mainClass: 'mfp-fade'
  removalDelay: 150
  preloader: false
  fixedContentPos: false

###
script = document.createElement('script')

playFullscreen = ->
  iframe = $('#movie')[0]
  requestFullScreen = iframe.requestFullScreen or iframe.mozRequestFullScreen or iframe.webkitRequestFullScreen
  if requestFullScreen
    requestFullScreen.bind(iframe)()
  player.playVideo()
  return

onPlayerStateChange = ->
  if player.getPlayerState() == 2
    if document.webkitCancelFullScreen
      document.webkitCancelFullScreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else if document.msExitFullscreen
      document.msExitFullscreen()
    else if document.cancelFullScreen
      document.cancelFullScreen()
    else if document.exitFullscreen
      document.exitFullscreen()
  return

script.src = 'https://www.youtube.com/iframe_api'
firstScript = document.getElementsByTagName('script')[0]
firstScript.parentNode.insertBefore script, firstScript
player = undefined
iframe = undefined

#play = document.getElementById('play');

$('#play').on 'click', ->
  if player == undefined
    new_player = true
    player = new (YT.Player)('movie',
      videoId: 'fhwj6m2cgEY'
      playerVars:
        'showinfo': 0
        'autohide': 1
        'rel': 0
        'loop': 1
        'hd': 1
        'fs': 0
        'autoplay': 1
      events: onStateChange: onPlayerStateChange)
  playFullscreen()
  return
###

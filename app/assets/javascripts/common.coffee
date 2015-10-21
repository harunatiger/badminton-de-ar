# common.coffee

# landing-page slideshow
slideSwitch = ->
  $active = $('#slideshow li.active')
  if $active.length == 0
    $active = $('#slideshow li:last')
  $next = if $active.next().length then $active.next() else $('#slideshow li:first')
  $active.addClass 'last-active'
  $next.css(opacity: 0.0).addClass('active').animate { opacity: 1.0 }, 1000, ->
    $active.removeClass 'active last-active'
    return
  return

# onload
$ ->

  # style zip-code
  setPostcode = (postcode) ->
    if postcode.length == 7
      postcode = [
        postcode.slice(0, 3)
        '-'
        postcode.slice(3)
      ].join('')
    postcode

  # auto address
  $('#user-zipcode').change ->
    zip = setPostcode($(this).val())
    if !zip
      return
    $(this).val zip
    url = '//api.zipaddress.net/?callback=?'
    query = 'zipcode': zip
    $.getJSON url, query, (json) ->
      $('#user_where_you_live, #profile_location').val(json.pref + json.address).focus()
      return
    return

  # common partial
  # header event switch
  if $('.header--sp').css('display') == 'block'
    # sidenav switch
    $('a.burger--sp').on 'click', ->
      $('body').addClass('slideout')
    $('.nav-mask--sp').on 'click', ->
      $('body').removeClass('slideout')

    # search modal
    $('.search-modal-trigger').on 'click', ->
      $('body').removeClass('slideout')
      $('#search-modal--sp').modal()
    $('#sp-search-field').on 'click', ->
      $('body').removeClass('slideout')
      $('#search-modal--sp').modal()
    $('.header-search-dummy').on 'click', ->
      $('body').removeClass('slideout')
      $('#search-modal--sp').modal()

  if $('.header--sp').css('display') == 'block' || $('body').hasClass('welcome index')
    # guest-flow modal
    $('.guest-flow-trigger').on 'click', ->
      if $('.header--sp').css('display') == 'block'
        # sidenav switch
        $('body').removeClass('slideout')
      $('body').addClass('paper')
      $('#guest-flow').modal()

    $('.close-guest-flow').on 'click', ->
      $('body').removeClass('paper')


  # subnav
  if $('.subnav').length
    # subnav get active-class
    # pageName = $('body').get(0).className.split(" ")[0];
    # $('.' + pageName, '.subnav').addClass('active')

    # subnav sticky
    # just temporary timeout
    setTimeout (->
      bodyHeight = $('body').outerHeight()
      stickyNavTop = $('.subnav').offset().top

      if $('body').hasClass('listings show')
        photoHeight = $('#photos').outerHeight()
        headerHeight = $('#header').outerHeight()
        footerHeight = $('footer').outerHeight()
        neighborHeight = $('#neighborhood').outerHeight()
        #similarHeight = $('#similar-listings').outerHeight()
        #priceHeight = $('#pricing').outerHeight()
        bookHeight = $('#talk_to').outerHeight()
        alertHeight = $('.alert-absolute').outerHeight()
        alertErrorHeight = $('.alert-error').outerHeight()
        #tempCount = bodyHeight - (footerHeight + neighborHeight + similarHeight + bookHeight + 37.5 + 25)
        tempCount = bodyHeight - (footerHeight + neighborHeight + bookHeight + alertErrorHeight + alertHeight + 37.5 + 40)
        stickyBoxTop = $('#summary').offset().top - 1
      stickyNav = ->
        scrollTop = $(window).scrollTop()
        if $('body').hasClass('listings show')
          if scrollTop >= stickyBoxTop && scrollTop < tempCount
            $('.subnav').attr 'aria-hidden','false'
            # media query
            if ($('div.talk_to-wrapper').css('float') == 'right')
              $('#talk_to').addClass('fixed').removeAttr 'style'
          else if scrollTop >= tempCount
            # media query
            if ($('div.talk_to-wrapper').css('float') == 'right')
              #tempPos1 = tempCount - (photoHeight + headerHeight) + priceHeight
              tempPos1 = tempCount - (photoHeight + headerHeight)+ 37.5 + 40
              $('#talk_to').removeClass 'fixed'
              $('#talk_to').css({
                'top': tempPos1 + 'px',
                'position': 'absolute'
              })
          else
            $('#talk_to').removeClass('fixed').removeAttr 'style'
            $('.subnav').attr 'aria-hidden','true'
          return
        else
          if scrollTop >= stickyNavTop
            $('.subnav, .manage-listing-nav').addClass 'pinned'
            $('.subnav-placeholder').removeClass 'hide'
          else
            $('.subnav, .manage-listing-nav').removeClass 'pinned'
            $('.subnav-placeholder').addClass 'hide'
          return
        return
      stickyNav()
      $(window).scroll ->
        stickyNav()
        return

      # window resize
      timer = false
      $(window).resize ->
        if timer != false
          clearTimeout timer
        timer = setTimeout((->
          console.log 'resized'
          stickyNav()
          return
        ), 200)
        return
    ), 1000

  # tooltip
  if $('.tooltip-trigger').length
    $('.tooltip-trigger').popover
      html: true
      trigger: 'hover'
      content: ->
        temp = $(this).attr('id')
        $('.' + temp).html()

  # tooltip 2
  $('[data-toggle="tooltip"]').tooltip()

  # welcome#index
  if $('body').hasClass('welcome index')

    # ellipsis guide_list comment
    $setElm = $('.introducing > span')
    cutFigure = '50'
    afterTxt = ' …'
    $setElm.each ->
      textLength = $(this).text().replace(/\s+/g,'').length
      textTrim = $(this).text().substr(0, cutFigure)
      if cutFigure < textLength
        $(this).html(textTrim + afterTxt).css visibility: 'visible'
      else if cutFigure >= textLength
        $(this).css visibility: 'visible'
      return

    # landing-page slideshow
    setInterval slideSwitch, 5000

    # bootstrap datepicker
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'ja'

    $('#charmer').carousel()

  # google place-auto-complete
  #initialize()
  # google place-auto-complete2
  #if $('body').hasClass('dashboard guest_reservation_manager')
    #initialize2()

  # registrations#new & registrations#create
  if $('body').hasClass('registrations new') || $('body').hasClass('registrations create')

    loginReady = ->
      $('.sns-buttons').addClass('hide')
      $('.signup-form').removeClass('hide')
      $('.social-links').removeClass('hide')
      $('#to-signup-form').addClass('hide')
      $('.policy-wrapper').addClass('hide')
      return

    if $('.alert-error > div').length
      loginReady()

    $('#to-signup-form').on 'click', ->
      loginReady()

  #pair_guide_list-trigger
  if $('body').hasClass('profiles show') || $('body').hasClass('listings show')
    $('a.pair_guide_list-trigger').on 'click', ->
      $('#pair_guide_list').modal()
      return false

  #tour-listing
  if $('.tour-listing').length
    # ellipsis discovery title
    $setElm1 = 0
    $setElm1 = $('.tour-listing h5')
    cutFigure1 = '40'
    afterTxt1 = ' …'
    $setElm1.each ->
      textLength1 = $(this).text().replace(/\s+/g,'').length
      textTrim1 = $(this).text().replace(/\s+/g,'').substr(0, cutFigure1)
      if cutFigure1 < textLength1
        $(this).html(textTrim1 + afterTxt1).css visibility: 'visible'
      else if cutFigure1 >= textLength1
        $(this).css visibility: 'visible'
      return


    ###
    # circle map
    cityCircle = undefined

    initialize = ->
      mapOptions =
        scrollwheel: false
        zoom: 13
        #center: new (google.maps.LatLng)(gon.listing.latitude, gon.listing.longitude)
        center: new (google.maps.LatLng)(35.319225, 139.546687)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      map = new (google.maps.Map)(document.getElementById('tour-map'), mapOptions)

      circleOptions =
        strokeColor: '#17AEDF'
        strokeOpacity: 0.8
        strokeWeight: 1
        fillColor: '#17AEDF'
        fillOpacity: 0.35
        map: map
        # center: new (google.maps.LatLng)(gon.listing[0].latitude, gon.listing[0].longitude)
        center: new (google.maps.LatLng)(35.319225, 139.546687)
        radius: Math.sqrt(100) * 100
      # Add the circle for this city to the map.
      cityCircle = new (google.maps.Circle)(circleOptions)
      return

    google.maps.event.addDomListener window, 'load', initialize
    ###


# functions ==============================

# google place autocomplete
###
initialize = ->
  input = document.getElementById('location')
  options = {
    types: [ '(cities)' ],
    componentRestrictions: {
      country: "jp"
    }
  }
  #options = types: [ '(cities)' ]
  autocomplete = new (google.maps.places.Autocomplete)(input, options)
  location_being_changed = undefined

  google.maps.event.addListener autocomplete, 'place_changed', ->
    location_being_changed = false
    return

  $('#location').keydown (e) ->
    if e.keyCode == 13
      if location_being_changed
        e.preventDefault()
        e.stopPropagation()
    else
      location_being_changed = true
    return
  return
###

# google place autocomplete
###
initialize2 = ->
  input = document.getElementById('location2')
  options = {
    types: [ '(cities)' ],
    componentRestrictions: {
      country: "jp"
    }
  }
  #options = types: [ '(cities)' ]
  autocomplete = new (google.maps.places.Autocomplete)(input, options)
  location_being_changed = undefined

  google.maps.event.addListener autocomplete, 'place_changed', ->
    location_being_changed = false
    return

  $('#location2').keydown (e) ->
    if e.keyCode == 13
      if location_being_changed
        e.preventDefault()
        e.stopPropagation()
    else
      location_being_changed = true
    return
  return
###

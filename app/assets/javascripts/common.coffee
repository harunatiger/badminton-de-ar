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

  # TMP edit
  # $('#request_withdrawal').modal('show')

  # footer instagram widget
  feed = new Instafeed(
    target: 'instafeed'
    get: 'user'
    userId: '3126102602'
    clientId: 'd35c9e83f88c456487e7779d3c9d5f93'
    accessToken: '205858901.d35c9e8.6eb2ad8197614e169dfd9f3903171ce2'
    resolution: 'standard_resolution'
    links: true
    limit: 6
    template: '<li><a href="{{link}}" target="_blank"><div style="background-image: url({{image}})"></div></a></li>'
  )
  feed.run()

  # sns lazyload
  if $('#fb-widget').length
    loadAPI = ->
      js = document.createElement('script')
      js.src = '//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=197428196987151&version=v2.6'
      document.body.appendChild js
      return
    window.onscroll = ->
      rect = document.getElementById('fb-widget').getBoundingClientRect()
      if rect.top < window.innerHeight
        loadAPI()
        window.onscroll = null
      return

  if $('.tour-listing .listing-area').length
    $('.tour-listing').each (index) ->
      titleHeight = $(this).find('h5').height()
      if titleHeight >= 42
        $(this).find('.card-body').css('padding-top','5px')

    maxlength = 60
    $('.tour-listing .listing-area').each (index) ->
      elementChild = $(this).children('a')
      elementChildNum = elementChild.length
      i = 0
      j = 0
      sum = 0
      while i < elementChildNum
        str = $.trim($(elementChild).eq(i).text())
        sum = sum + str.length
        if sum >= maxlength
          j = i
          break
        i++
      if j != 0 && j != elementChildNum
        while j < elementChildNum
          $(elementChild).eq(j).remove()
          j++
        $(this).append('...')


  # dropdown-nav
  #old_item = undefined
  timeout = undefined
  $('.user-nav-toggle').mouseenter ->
    item_selected = $('.user-nav', this)
    clearTimeout timeout
    #if old_item
    #  old_item.hide()
    item_selected.show()
    return
  $('.user-nav-toggle').mouseleave ->
    item_selected = $('.user-nav', this)
    #old_item = item_selected
    timeout = window.setTimeout((->
      item_selected.hide()
      return
    ), 500)
    return

  # content expand
  if $('.expandable').length
    $('.expandable').each ->
      exContent = $('.expandable-content', this).height()
      exInner =  $('.expandable-inner', this).height()
      if exContent >= exInner
        $(this).addClass('expanded')
      if exInner <= 65
        $('.expandable-indicator', this).hide()
        $('.expandable-trigger-more-text', this).hide()

    $('.expandable-trigger-more').on 'click', ->
      tempP = $(this)
      tempWrap = tempP.parents('.expandable')
      if !tempWrap.hasClass('expanded')
        tempHeight = $('div.expandable-inner', tempWrap).height() + 12.5
        $('div.expandable-content', tempWrap).height(tempHeight)
        tempWrap.addClass('expanded')
        if tempP.is('a')
          return false
      return

  # profile#show
  if $('body').hasClass('profiles show') || $('body').hasClass('listings show') || $('body').hasClass('listings preview')

    # profile tour location
    initialize = ->
      bounds = new google.maps.LatLngBounds()
      if gon.listing_destinations[0]
        latitude = gon.listing_destinations[0].latitude
        longitude = gon.listing_destinations[0].longitude
      else
        latitude = 0
        longitude = 0
        gon.listing_destinations[0] = {latitude: latitude, longitude: longitude}

      mapOptions =
        scrollwheel: false
        zoom: 13
        center: new (google.maps.LatLng)(latitude, longitude)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      if $('body').hasClass('profiles show')
        map = new (google.maps.Map)(document.getElementById('tour-map'), mapOptions)
      else if $('body').hasClass('listings')
        map = new (google.maps.Map)(document.getElementById('location'), mapOptions)

      # Multiple Markers
      # Info Window Content
      markers = new Array()
      # infoWindowContent = new Array()
      gon.listing_destinations.map (l) ->
        tmp_marker = new Array()
        tmp_marker.push(l.title, l.latitude, l.longitude, l.id, l.listing_id)
        markers.push(tmp_marker)

      # Display multiple markers on a map
      infoWindow = new google.maps.InfoWindow()

      # Loop through our array of markers & place each one on the map
      i = 0
      while i < markers.length
        position = new (google.maps.LatLng)(markers[i][1], markers[i][2])
        bounds.extend position
        if markers[i][4]
          icon = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|00D9FF'
        else
          icon = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FFD000'

        marker = new (google.maps.Marker)(
          position: position
          map: map
          icon: icon
          title: markers[i][0]
          id: markers[i][3]
          listing_id: markers[i][4])

        # Allow each marker to have an info window
        if $('body').hasClass('profiles show')
          google.maps.event.addListener marker, 'click', ->
            clicked_marker = this
            target = ''
            id = ''
            if clicked_marker.listing_id
              target = 'listings'
              id = clicked_marker.listing_id
            else
              target = 'spots'
              id = clicked_marker.id

            $.ajax(
              type: 'GET'
              url: '/search/get_information'
              data: {id: id, target: target}
            ).done (data) ->
              infoWindow.setContent data
              infoWindow.open map, clicked_marker
            return

        # Automatically center the map fitting all markers on the screen
        map.fitBounds bounds
        i++

        # Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
        #boundsListener = google.maps.event.addListener(map, 'bounds_changed', (event) ->
        #  @setZoom 14
        #  google.maps.event.removeListener(boundsListener)
        #  return
        #)
    google.maps.event.addDomListener window, 'load', initialize

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
      if $('body').hasClass('plan4U') || $('body').hasClass('plan4U_kyoto') || $('body').hasClass('plan4U_hokkaido')
        $('.plan4U-navigation-inner').collapse('toggle')
      else
        $('body').addClass('slideout')
        if $('.nav-content--sp').hasClass('logged-in')
          nav_content_height = $('.nav-content--sp').height()
          nav_header_height = $('.nav-header').height()
          $('.nav-menu-wrapper').css('height', nav_content_height - nav_header_height+'px')

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

    # move to $('.close-three-reasons').on 'click', ->
    #$('.close-guest-flow').on 'click', ->
    #  $('body').removeClass('paper')
    #  $('#guest-flow').modal('hide')
    #  $('.panel-close-fix').hide()

    # about guide modal
    $('.about-guide-trigger').on 'click', ->
      if $('.header--sp').css('display') == 'block'
        # sidenav switch
        $('body').removeClass('slideout')
      $('body').addClass('paper')
      $('#about-guide').modal()
      return false

    $('.close-about-guide').on 'click', ->
      $('body').removeClass('paper')

    # three reasons modal
    ###
    $('.three-reasons-trigger').on 'click', ->
      if $('.header--sp').css('display') == 'block'
        # sidenav switch
        $('body').removeClass('slideout')
      $('body').addClass('paper')
      $('#three-reasons').modal()
      $('.panel-close-fix').show()
      return false
    ###

    # guest-flow modal
    $('.guest-flow-trigger').on 'click', ->
      if $('.header--sp').css('display') == 'block'
        # sidenav switch
        $('body').removeClass('slideout')
      $('body').addClass('paper')
      $('#guest-flow').modal()
      $('.close-guest-flow').show()
      return false

    # learn more modal
    $('.learn-more-trigger').on 'click', ->
      if $('.header--sp').css('display') == 'block'
        # sidenav switch
        $('body').removeClass('slideout')
      $('body').addClass('paper')
      $('#learn-more').modal()
      $('.close-learn-more').show()
      return false

    # close learn more
    $('.close-learn-more').on 'click', ->
      $('body').removeClass('paper')
      $('#learn-more').modal('hide')
      $(this).hide()
      return false

    # close guest flow
    $('.close-guest-flow').on 'click', ->
      $('body').removeClass('paper')
      $('#guest-flow').modal('hide')
      $(this).hide()
      return false

  # subnav
  if $('.subnav').length && !$('body').hasClass('friends')
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
        ###
        else
          if scrollTop >= stickyNavTop
            #$('.subnav, .manage-listing-nav, .manage-listing-detail').addClass 'pinned'
            $('.subnav-placeholder').removeClass 'hide'
          else
            #$('.subnav, .manage-listing-nav, .manage-listing-detail').removeClass 'pinned'
            $('.subnav-placeholder').addClass 'hide'
          return
        return
        ###
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

    # feature carousel
    # $('#feature-carousel').carousel()

    #slider
    $('#feature-carousel').sliderPro
      width: 960
      height: 500
      # aspectRatio: 1.5
      visibleSize: '100%'
      forceSize: 'fullWidth'
      arrows: true
      fadeArrows: false
      autoSlideSize: true
      autoplayDelay: 3000
      slideAnimationDuration: 1000
      buttons: false
      keyboard: false
      slideDistance: 1
      breakpoints:
        1099:
          width: 640
          height: 340
        767:
          width: '100%'
          autoHeight: true
          visibleSize: 'auto'
          forceSize: 'none'
      # scale class
      gotoSlide: (event) ->
        $('.sp-slide').removeClass('sp-prev sp-next')
        if $('.sp-selected').next().length
          $('.sp-selected').next().addClass('sp-next')
        else
          $('.sp-slide:first').addClass('sp-next')

        if $('.sp-selected').prev().length
          $('.sp-selected').prev().addClass('sp-prev')
        else
          $('.sp-slide:last').addClass('sp-prev')
        return

    # lazyload
    $('.discovery-card, .tour-cover, .youtube-container > div, .guide-card-background, .media-cover-img > div, .img-lazyload').lazyload
      effect: 'fadeIn'

    if $('.announcement_belt').length
      $('body').addClass('announcement')

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
    ###
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'ja'
    ###

    # $('#charmer').carousel()

    $('#morebook').on 'click', ->
      $(this).parent().removeClass('show--sp').hide()
      $('#sp-shy-book').removeClass('hide--sp')
      return false

    $('#moreguide').on 'click', ->
      if $('#allguides').is(':hidden')
        $(this).empty()
        $(this).prepend('Close' + '<i class="fa fa-caret-up"></i>')
        $('#allguides').slideDown 'normal', ->
          position = $('.guide_list-tiles .col-lg-4:eq(2)').offset().top
          $('html,body').animate { scrollTop: position }
      else
        $(this).empty()
        $(this).prepend('See All' + '<i class="fa fa-caret-down"></i>')
        $('#allguides').slideUp 'normal', ->
          position = $('.guide_list-wrapper').offset().top
          $('html,body').animate { scrollTop: position }
      return false

  # google place-auto-complete
  #initialize()
  # google place-auto-complete2

  #if $('body').hasClass('dashboard guest_reservation_manager')
  #  $('.cancel-reservation-form').on 'submit', ->
  #    return confirm('この予約をキャンセルします。本当によろしいですか？')

  #if $('body').hasClass('message_threads show')
  #  $('.cancel-reservation-form').on 'submit', ->
  #    return confirm('この予約をキャンセルします。本当によろしいですか？')

  # dashboard
  if $('body').hasClass('dashboard') or $('body').hasClass('listings show') or $('body').hasClass('message_threads show')
    $('a.about-support-guide-trigger').on 'click', ->
      $('#about_support_guide').modal()
      return false
    $('a.pair_guide_list-trigger').on 'click', ->
      $('#pair_guide_list').modal()
      return false

  # registrations#new & registrations#create
  if $('body').hasClass('registrations new') || $('body').hasClass('registrations create') || $('body').hasClass('listings show') || $('body').hasClass('profiles show') || $('body').hasClass('static_pages plan4U') || $('body').hasClass('static_pages plan4U_kyoto') || $('body').hasClass('static_pages plan4U_hokkaido') || $('body').hasClass('spots show')

    loginReady = ->
      $('.sns-buttons').addClass('hide')
      $('.signup-form').removeClass('hide')
      $('.social-links').removeClass('hide')
      $('#to-signup-form').addClass('hide')
      $('.policy-wrapper').addClass('hide')
      return false

    if $('.alert-error > div').length
      loginReady()

    $('#to-signup-form').on 'click', ->
      loginReady()

  #pair_guide_list-trigger
  if $('body').hasClass('profiles show') || $('body').hasClass('listings show') || $('body').hasClass('listings preview')
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

  #Form Change Confirm
  if $('body').is('.profiles.edit') || $('body').is('.profiles.self_introduction') || $('body').is('.profile_keywords.new') || $('body').is('.profile_keywords.edit') || $('body').is('.profile_images.edit') || $('body').is('.profile_identities.edit') || $('body').is('.profile_banks.edit') || $('body').is('.listings.edit') || $('body').is('.listings.new') || $('body').is('.listing_images.manage') || $('body').is('.listing_details.manage') || $('body').is('.listing_details.manage')
    isChanged = false
    form_change_target = ''

    handleClick = (event, target) ->
      if event.hasClass('info--sp')
        return
      if event.hasClass('close-layer--sp')
        return
      if event.hasClass('burger--sp')
        return
      if event.hasClass('price--sp')
        return
      if $('body').is('.profiles.self_introduction') and target == '#'
        return
      if $('body').is('.profiles.edit') and target == "javascript:void(0)"
        return
      if $('body').is('.profile_keywords.new') and target == '#'
        return
      if $('body').is('.profile_keywords.edit') and target == '#'
        return
      if $('body').is('.listing_images.manage') and target == '#'
        return
      if isChanged == true
        form_change_target = target
        $('#form_change_confirm').modal('show')
        return false
      else
        return

    modalyesClick = ->
      $('#form_change_confirm').modal('hide')
      window.location.href = form_change_target
      isChanged == false

    $('form').change -> isChanged = true
    $('form').submit ->
      isChanged = false
      return
    $('a').on 'click', ->
      if $(this).hasClass("ignore_form_change")
        return
      if $(this).attr('data-dismiss') == "modal"
        return
      if $(this).attr('href') == "#"
        return
      if $(this).attr('href') == "javascript:void(0)"
        return
      else
        handleClick($(this),$(this).attr('href'))
    $('#form_change_confirm #pagemove').on 'click', -> modalyesClick()
    $('#form_change_confirm .btn-default').on 'click', ->
      if $('body').hasClass('slideout')
        $('body').removeClass('slideout')
      if $('.manage-listing-nav').hasClass('show-off')
        if $('.manage-listing-nav').css('display') == "block"
          $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').hide()
          $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').removeClass('show-off')
        else
          $('.manage-listing-detail, .close-layer--sp').hide()
          $('.manage-listing-detail, .close-layer--sp').removeClass('show-off')
        return

  #IME disabled
  $(document).on 'keyup', '.imeoff', ->
    noSbcRegex = /[^\x00-\x7E]+/g
    target = $(this)
    if !target.val().match(noSbcRegex)
      return
    window.setTimeout (->
      target.val target.val().replace(noSbcRegex, '')
      return
    ), 1
    return

  if $('body').hasClass('listings show')
    $('#new_user').submit ->
      targetForm = $(this).closest('form')
      spinner = $('.spinner', targetForm)
      spinner.spin('flower', 'white')
      $('.btn-frame > .btn', targetForm).addClass('text-disappear')
      return

  if $('body').hasClass('plan4U') || $('body').hasClass('plan4U_kyoto') || $('body').hasClass('plan4U_hokkaido')
    $('#moreguide').on 'click', ->
      $(this).remove()
      $('.hide-guest').removeClass('hide-guest')
      return false

    $(document).on 'click', '.sign_up_form', (e) ->
      to_user_id = $(this).attr('user_id')
      if to_user_id
        $("#sns_button").attr("href", "/users/before_omniauth?to_user_id=" + to_user_id)
        $('.facebook_link').attr("href", "/users/before_omniauth?to_user_id=" + to_user_id)
        $("#new_user").attr("action", "/users?to_user_id=" + to_user_id)
        $('#sign_up_form').modal()
      e.preventDefault()

    # scroll to howto
    $('.scroll-to-howtouse').on 'click', (e) ->
      position = $('#howtouse').offset().top
      $('html,body').animate { scrollTop: position }
      $('.plan4U-navigation-inner').collapse('hide')
      e.preventDefault()

    # scroll to guides
    $('.scroll-to-guides').on 'click', (e) ->
      position = $('#recommended-guides').offset().top
      $('html,body').animate { scrollTop: position }
      $('.plan4U-navigation-inner').collapse('hide')
      e.preventDefault()

  $('.facebook_button').on 'click', ->
    $(this).addClass("disabled")
    return

  $('.facebook_link').on 'click', ->
    $(this).hide()
    return

  $('#currency_code').on 'change', ->
    currency_code = $('#currency_code option:selected').text()
    $.ajax(
        type: 'POST'
        url: '/currencies/change_currency'
        data: {
          currency_code: currency_code
        }
     ).done (data) ->
      location.reload()

  # record access log for tag event
  $('.js-google-tag-manager').on 'click', ->
    tag_event = ''
    if $(this).hasClass('listing_message')
      tag_event = 'Tour-Talk to me'
    else if $(this).hasClass('listing_request')
      tag_event = 'Tour-Request Booking'
    else if $(this).hasClass('profile_message')
      tag_event = 'Profile-Talk to me'
    else if $(this).hasClass('complete_payment')
      tag_event = 'Reservation'
    else if $(this).hasClass('plan4U_message')
      tag_event = 'Plan4U-Talk to me'
    else if $(this).hasClass('login_email')
      tag_event = 'Login-Email'
    else if $(this).hasClass('login_facebook')
      tag_event = 'Login-Facebook'
    else if $(this).hasClass('signup_email')
      tag_event = 'Signup-Email'
    else if $(this).hasClass('signup_email_register')
      tag_event = 'Signup-EmailRegister'
    else if $(this).hasClass('signup_facebook')
      tag_event = 'Signup-Facebook'
    else if $(this).hasClass('profiles_signup_email')
      tag_event = 'Profile-Signup-Email'
    else if $(this).hasClass('profiles_signup_email_register')
      tag_event = 'Profile-Signup-EmailRegister'
    else if $(this).hasClass('profiles_signup_facebook')
      tag_event = 'Profile-Signup-Facebook'
    else if $(this).hasClass('listings_signup_email')
      tag_event = 'Tour-Signup-Email'
    else if $(this).hasClass('listings_signup_email_register')
      tag_event = 'Tour-Signup-EmailRegister'
    else if $(this).hasClass('listings_signup_facebook')
      tag_event = 'Tour-Signup-Facebook'

    $.ajax(
        type: 'POST'
        url: '/tag_events'
        data: {
          tag_event: tag_event
        }
     )
    return

  # search edit 20160913
  if $('body').hasClass('welcome index')
    # headroom
    currentOffset = 0
    $(window).scroll ->
      scrolltop = $(this).scrollTop()
      if scrolltop > 650
        $('#headroom-header').addClass('headroom--pinned').removeClass 'headroom--unpinned'
      else if scrolltop < 350
        $('#headroom-header').addClass('headroom--unpinned').removeClass 'headroom--pinned'
      currentOffset = scrolltop
      return

    #! auto complete
    initPAC = ->
      input = document.getElementById('location-search')
      options = {
        #types: [ '(cities)' ],
        componentRestrictions: {
          country: "jp"
        }
      }
      autocomplete = new (google.maps.places.Autocomplete)(input, options)
      location_being_changed = undefined

      google.maps.event.addListener autocomplete, 'place_changed', ->
        place = this.getPlace()
        if place.geometry
          $('#search_form').find('#search_latitude').val place.geometry.location.lat()
          $('#search_form').find('#search_longitude').val　place.geometry.location.lng()
        location_being_changed = false
        return

      $('#location-search').keydown (e) ->
        if e.keyCode == 13
          if location_being_changed
            e.preventDefault()
            e.stopPropagation()
        else
          $('#search_form').find('#search_latitude').val ''
          $('#search_form').find('#search_longitude').val　''
          location_being_changed = true
        return
      return
    #! auto complete activate
    initPAC()

    #! header auto complete
    initHeaderPAC = ->
      input = document.getElementById('header-location-search')
      options = {
        #types: [ '(cities)' ],
        componentRestrictions: {
          country: "jp"
        }
      }
      autocomplete = new (google.maps.places.Autocomplete)(input, options)
      location_being_changed = undefined

      google.maps.event.addListener autocomplete, 'place_changed', ->
        place = this.getPlace()
        if place.geometry
          $('#headroom-header').find('#search_latitude').val place.geometry.location.lat()
          $('#headroom-header').find('#search_longitude').val　place.geometry.location.lng()
        location_being_changed = false
        return

      $('#header-location-search').keydown (e) ->
        if e.keyCode == 13
          if location_being_changed
            e.preventDefault()
            e.stopPropagation()
        else
          $('#headroom-header').find('#search_latitude').val ''
          $('#headroom-header').find('#search_longitude').val　''
          location_being_changed = true
        return
      return
    #! header auto complete activate
    initHeaderPAC()

    # search edit 20160914

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

#listings.coffee
$ ->

  # listings#new
  if $('body').hasClass('listing_details manage')

    # add input file for pics
    ###
    $('.add-file-input').on 'click', ->
      $(this).before('<input type="file">')
      return false
    ###

    # disabled submit-btn to active
    ###
    $('#new_listing input[type="text"]').on 'blur', ->
      if $('#listing_title').val() != '' && $('#listing_zipcode').val() != '' && $('#listing_location').val() != ''
        $('.btn-primary').removeClass('disabled')
    ###
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
    $('#listing_detail_zipcode').change ->
      zip = setPostcode($(this).val())
      if !zip
        return
      $(this).val zip
      url = '//api.zipaddress.net/?callback=?'
      query = 'zipcode': zip
      $.getJSON url, query, (json) ->
        $('#listing_detail_location').val(json.pref + json.address).focus()
        return
      return

  # confections#manage, tools#manage
  if $('body').hasClass('confections manage') || $('body').hasClass('tools manage')
    $('form.url-check').validate
      rules:
        'tool[url]':
          required: false
          url: true
      messages: 'tool[url]':
        url: 'URLアドレスを入力してください'


  # listings#search
  ###
  if $('body').hasClass('listings search')
    # sp filter toggle
    $('.js-small-filter-toggle').on 'click', ->
      $(this).addClass('hide')
      $('.no-listings-block').hide()
      $('.sidebar').addClass('filters-open')
      $('body').scrollTop(0)
    $('.js-small-filters-close').on 'click', ->
      $('.js-small-filter-toggle').removeClass('hide')
      $('.sidebar').removeClass('filters-open')
      $('.no-listings-block').show()

    # sidebar header switch
    setTimeout (->
      bodyHeight = $('body').outerHeight()
      sidebarHeader = $('.sidebar-header')
      stickyNavTop = $('.sidebar-header').position().top
      stickyHead = ->
        scrollTop = $('.sidebar').scrollTop()
        if scrollTop > stickyNavTop
          $('body').addClass('stuck')
          $('.sidebar').before(sidebarHeader)
          $('.sidebar-placeholder').removeClass 'hide'
        else
          $('.filters').after(sidebarHeader)
          $('body').removeClass('stuck')
          $('.sidebar-placeholder').addClass 'hide'
        return

      checkSize = ->
        if $('footer').css('display') == 'block'
          scrollTop = $('body').scrollTop()
          bodyHeight = $('body').outerHeight()
          footerHeight = $('footer').outerHeight()
          footerPosi = $('.results-footer').offset().top
          winHeight = $(window).outerHeight()
          tempPosi = bodyHeight - winHeight - footerHeight - 90
          tempPosi2 = footerPosi - 50

          if scrollTop >= tempPosi && bodyHeight >= winHeight
            $('.filters-btn').removeClass('fixed').addClass('bottom').css('top', tempPosi2)
          else
             $('.filters-btn').addClass('fixed').removeClass('bottom').removeAttr('style')
        else
        return

      stickyHead()
      checkSize()

      $('.sidebar').scroll ->
        stickyHead()
        return

      $(window).scroll ->
        checkSize()
        return

      # window resize
      timer = false
      $(window).resize ->
        if timer != false
          clearTimeout timer
        timer = setTimeout((->
          stickyHead()
          checkSize()
          return
        ), 200)
        return
    ), 300

    # wishlist modal
    $('.wishlist-button label').on 'click', ->
      $('#modal-wishlist').modal()

    $('#hogehogehogehoge').on 'click', ->
      $('#modal-wishlist').modal()

    # bootstrap datepicker
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'ja',
      orientation: 'top auto',
      format: "yyyy-mm-dd"

    # range slider
    $("#price-range").slider
      min: 0
      max: 100000
      step: 100
      range: true
      value: [500, 50000]
      tooltip: 'always'
      tooltip_split: true
      handle: 'square'

    # filter open-close
    sidebarHeight = $('.sidebar').outerHeight()
    filtersHeight = $('.filters.collapse').outerHeight()
    tempHeight = sidebarHeight - filtersHeight
    $('.filters').css 'bottom', tempHeight + 'px'
    $('.filters-placeholder').height filtersHeight + 'px'

    $('.show-filters').on 'click', ->
      $('.filters-placeholder').removeClass('hide')
      $('.filters').animate {bottom: '0px'}, 300
      $('.filters').removeClass('collapse')
      $('.sidebar-header').addClass('transparent')
      setTimeout (->
        $('.sidebar').addClass('filters-open')
      ), 500

    $('.search-button').on 'click', ->
      $('.sidebar').removeClass('filters-open')
      $('.filters').animate {bottom: tempHeight + 'px'}, 300
      setTimeout (->
        $('.sidebar-header').removeClass('transparent')
        $('.filters-placeholder').addClass('hide')
        $('.filters').addClass('collapse')
      ), 500

    # search circle map
    cityCircle = undefined

    initialize = ->
      bounds = new google.maps.LatLngBounds()
      mapOptions =
        scrollwheel: false
        zoom: 13
        center: new (google.maps.LatLng)(gon.listings[0].latitude, gon.listings[0].longitude)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      map = new (google.maps.Map)(document.getElementById('map'), mapOptions)

      # Multiple Markers
      # Info Window Content
      markers = new Array()
      infoWindowContent = new Array()
      gon.listings.map (l) ->
        tmp_marker = new Array()
        tmp_info = new Array()
        tmp_marker.push(l.title, l.latitude, l.longitude)
        markers.push(tmp_marker)
        tmp_info.push('<div class="info_content"><img src="' + l.cover_image.thumb.url + '"><h3>' + l.title + '</h3><p>' + l.description  + '</p></div>')
        infoWindowContent.push(tmp_info)

      # Display multiple markers on a map
      infoWindow = new google.maps.InfoWindow()

      # Loop through our array of markers & place each one on the map
      i = 0
      while i < markers.length
        position = new (google.maps.LatLng)(markers[i][1], markers[i][2])
        bounds.extend position
        marker = new (google.maps.Marker)(
          position: position
          map: map
          title: markers[i][0])
        # Allow each marker to have an info window
        google.maps.event.addListener marker, 'click', do (marker, i) ->
          ->
           infoWindow.setContent infoWindowContent[i][0]
           infoWindow.open map, marker
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
  ###

  # listings#show
  if $('body').hasClass('listings show')

    # open include_what
    $('a.include_what_trigger').on 'click', ->
      $('#include_what').modal()
      return false

    # gallery
    $('.photo-box').magnificPopup
      delegate: '.galon'
      type: 'image'
      gallery:
        enabled: true

    $('.galon-trigger').on 'click', ->
      $('.photo-box').magnificPopup('open')

    # price culc
    tourPriceSingleContainer = $('#tour-price-single')
    tourPriceSingle = 0
    tourPriceBase = Number($('#tour-price-base').text())
    tourPriceOption = Number($('#tour-price-option').text())
    tourMemberCulcedContainer = $('#tour-member_culced')
    tourPriceBaseCulcedContainer = $('#tour-price-base_culced')
    tourPriceOptionCulcedContainer = $('#tour-price-option_culced')
    serviceCostCulcedContainer = $('#service-cost_culced')
    tourPriceResultCulcedContainer = $('#tour-price-result_culced')

    tourPriceSingle = tourPriceBase + tourPriceOption
    tourPriceSingleContainer.text(tourPriceSingle)

    priceCulc = ->
      $('#culc-container').show()
      numOfPeople = Number($('#num-of-people option:selected').text())
      tourMemberCulcedContainer.text(numOfPeople)
      tourPriceOptionCulcedContainer.text(tourPriceOption)
      tourPriceBaseCulced = tourPriceBase * numOfPeople
      tourPriceBaseCulcedContainer.text(tourPriceBaseCulced)
      serviceCostCulced = Math.floor((tourPriceBaseCulced + tourPriceOption) * 0.125)
      serviceCostCulcedContainer.text(serviceCostCulced)
      tourPriceResultCulcedContainer.text(tourPriceBaseCulced + tourPriceOption + serviceCostCulced)
      return

    $('#num-of-people select').on 'change', ->
      priceCulc()
    $('#checkin').on 'changeDate', ->
      priceCulc()

    # bootstrap datepicker
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'ja'

    # book_it_button action
    $('#book_it_button').on 'click', ->
      if $('#checkin').val() == ''
        $('#checkin').datepicker('show')
        return false

    # share-via-email modal
    $('#share-via-email-trigger').on 'click', ->
      $('#share-via-email').modal()


    #$('body').on 'fullscreenchange', ->
    #  alert 666

    # media query js width 1099px
    mediaQueryWidth1 = ->
      listingDescription = $('#listing-description')
      tourAction = $('#tour-action')
      tourOptionInfo = $('#tour-option-info')
      if($('.col-left').css('float') == "left")
        # evacuate fullscreen movie
        if(!$('#tour_movie').hasClass('vjs-fullscreen'))
          tourAction.insertBefore(tourOptionInfo)
      else
        # evacuate fullscreen movie
        if(!$('#tour_movie').hasClass('vjs-fullscreen'))
          tourAction.insertBefore(listingDescription)

    mediaQueryWidth1()

    timer = false
    $(window).resize ->
      if timer != false
        clearTimeout timer
      timer = setTimeout((->
        mediaQueryWidth1()
        return
      ), 200)
      return


    #scrollspy
    ###
    scrollMenu = ->
      array =
        '#photos': 0
        '#summary': 0
        '#reviews': 0
        #'#host-profile': 0
        '#neighborhood': 0
      $globalNavi = new Array
      for key of array
        if $(key).offset()
          array[key] = $(key).offset().top - 10
          $globalNavi[key] = $('.subnav-list li a[href="' + key + '"]')
      # スクロールイベントで判定
      for key of array
        if $(window).scrollTop() > array[key]
          $('.subnav-list li a').each ->
            $(this).attr 'aria-selected', false
            return
          $globalNavi[key] .attr 'aria-selected', true
      return

    setTimeout (->
      scrollMenu()
    ), 100

    $(window).scroll ->
      scrollMenu()
      return
    ###
    ###
    # expand text
    $('.expandable-trigger-more').on 'click', ->
      tempP = ''
      tempP = $(this)
      tempWrap = tempP.closest('.row-space-2')
      tempHeight = $('div.expandable-content > p', tempWrap).height()
      $('div.expandable-content', tempWrap).height(tempHeight)
      $('div.expandable-trigger-more', tempWrap).addClass('expanded')
    ###

    # show location
    initialize = ->
      mapOptions =
        scrollwheel: false
        zoom: 13
        center: new (google.maps.LatLng)(gon.listing.latitude, gon.listing.longitude)
        # center: new (google.maps.LatLng)(35.319225, 139.546687)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      map = new (google.maps.Map)(document.getElementById('location'), mapOptions)

      marker = new (google.maps.Marker)(
        position:  new (google.maps.LatLng)(gon.listing.latitude, gon.listing.longitude)
        map: map )
      return

    google.maps.event.addDomListener window, 'load', initialize

    ###
    # carousel
    if $('.carousel-item').length > 1
      singleCol = $('.carousel-item').outerWidth()
      colCount = $('.carousel-item').length
      tempCount = 1
      currentPos = undefined

      $('.carousel-chevron.right').removeClass('hide')
      $('.listings-container').width(singleCol * colCount)

      # click next
      $('.carousel-chevron.right').on 'click', ->
        currentPos = singleCol * tempCount
        $('.listings-container').css('left', '-' + currentPos + 'px')
        tempCount++

        $('.carousel-chevron.left').removeClass('hide')
        if(colCount <= 2)
          $('.carousel-chevron.right').addClass('hide')
        if(colCount == tempCount)
          $('.carousel-chevron.right').addClass('hide')
      # click prev
      $('.carousel-chevron.left').on 'click', ->
        currentPos = currentPos - singleCol
        $('.listings-container').css('left', '-' + currentPos + 'px')
        tempCount--

        if(tempCount <= 1)
          $('.carousel-chevron.left').addClass('hide')
          $('.carousel-chevron.right').removeClass('hide')

      # click photo
      $('#photos').find('.photo-slider-item').modalSlider({
        type: 'image',
        gallery: {
        enabled: true,
        navigateByImgClick: true
      },
      image: {titleSrc: 'title'}
      })
    ###

  # manage height equlizer
  if $('.manage-listing-nav').length && !$('body').hasClass('calendar')
    mContainerHeight = $('.manage-listing-content').outerHeight()
    setHeight = ->
      headerHeight = $('.common-header').outerHeight()
      mHeaderHeight = $('.manage-listing-header').outerHeight()
      winHeight = $(window).outerHeight()
      tempHeight1 = mContainerHeight + headerHeight + mHeaderHeight
      tempHeight2 = winHeight - (headerHeight + mHeaderHeight)
      if winHeight >= tempHeight1
        $('.manage-listing-content').css 'height', tempHeight2
      return
    setHeight()
    # window resize
    timer = false
    $(window).resize ->
      if timer != false
        clearTimeout timer
      timer = setTimeout((->
        setHeight()
        return
      ), 200)
      return

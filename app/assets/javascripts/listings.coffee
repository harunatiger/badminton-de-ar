#listings.coffee
$ ->

  # listings#new
  if $('body').hasClass('listing_details manage')

    # price imitation
    value_calc = ->
      space_check = 0
      car_check = 0
      fvMin = Number($('#listing_detail_min_num_of_people').val())
      fv = Number($('#listing_detail_max_num_of_people').val())
      $('#num-of-people select option').remove()
      i = fvMin
      while i <= fv
        $('#num-of-people select').append($('<option value="'+[i]+'">'+[i]+'</option>'));
        i++
      fv0 = Number($('#listing_detail_time_required').val())
      fv1 = Number($('#listing_detail_price').val())
      fv2 = Number($('#listing_detail_price_for_support').val())
      fv3 = Number($('#listing_detail_price_for_both_guides').val())
      fv4 = fv1 + fv2 + fv3
      if $('#listing_detail_space_option').is(':checked')
        fv5 = Number($('#listing_detail_space_rental').val())
      else
        fv5 = 0
      if $('#listing_detail_car_option').is(':checked')
        fv6 = Number($('#listing_detail_car_rental').val())
        fv7 = Number($('#listing_detail_gas').val())
        fv8 = Number($('#listing_detail_highway').val())
        fv9 = Number($('#listing_detail_parking').val())
      else
        fv6 = 0
        fv7 = 0
        fv8 = 0
        fv9 = 0
      fv10 = fv5 + fv6 + fv7 + fv8 + fv9
      fv11 = fv4 + fv10
      #fv12 = Math.ceil((fv11) * 0.145)
      #if fv11 <= 500
      #  fv12 = 0
      fv12 = 0
      fv13 = Number($('#listing_detail_guests_cost').val())
      fv14 = fv11 + fv12
      fv15 = $('#listing_detail_included_guests_cost').val()

      $('.max-num-of-people').text(fv)
      if fv0 == 24.5
        fv0 = '24h-)'
      else
        fv0 = fv0 + 'h)'
      $('.timelapse').text(fv0)
      $('.guide_price').text(fv4)
      $('.value_discharge.space_rental').text(fv5)
      $('.value_discharge.car_rental').text(fv6)
      $('.value_discharge.gas').text(fv7)
      $('.value_discharge.highway').text(fv8)
      $('.value_discharge.parking').text(fv9)
      $('.value_discharge.option_total').text(fv10)
      $('.value_discharge.service_fee').text(fv12)
      $('.value_discharge.guests_cost').text(fv13)
      $('.value_discharge.total_price').text(fv14)

      $('.value_discharge_option').each ->
        if $(this).text() == '0'
          $(this).parent().parent().addClass('hide')
        else
          $(this).parent().parent().removeClass('hide')

      $('#include_what .card-body p').text(fv15)

    $('.value_fragile').on 'change', ->
      value_calc()

    value_calc()

    # include what dismiss
    $('.iw-dismiss-btn').on 'click', ->
      $('#include_what').modal('hide')
    # option price collapse
    $('.price_option-check').each ->
      if $(this).is(':checked')
        $(this).parents('.collapse-heading').next().collapse('show')
        $(this).parents('.collapse-panel').addClass('active')

    $('.price_option-check').on 'click', (e) ->
      if $(this).is(':checked')
        $(this).parents('.collapse-heading').next().collapse('show')
        $(this).parents('.collapse-panel').addClass('active')
      else
        $(this).parents('.collapse-heading').next().collapse('hide')
        $(this).parents('.collapse-panel').removeClass('active')
      value_calc()


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

  if $('body').hasClass('listings new') && $('#about-guide-tg').length
    $('#about-guide-tg').modal('show')

  if $('body').hasClass('listings show') || $('body').hasClass('listing_details manage')

    # price calc
    tourPriceSingleContainer = $('#tour-price-single')
    tourPriceSingle = 0
    tourPriceBase = Number($('#tour-price-base').text())
    tourPriceOption = Number($('#tour-price-option').text())
    tourPriceOptionSingle = Number($('#tour-price-option-single').text())

    tourMemberCalcedContainer = $('#tour-member_calced')
    tourPriceBaseCalcedContainer = $('#tour-price-base_calced')
    tourPriceOptionCalcedContainer = $('#tour-price-option_calced')
    tourPriceOptionSingleCalcedContainer = $('#tour-price-option-single_calced')
    serviceCostCalcedContainer = $('#service-cost_calced')
    tourPriceResultCalcedContainer = $('#tour-price-result_calced')

    tourPriceSingle = tourPriceBase + tourPriceOption + tourPriceOptionSingle
    tourPriceSingleContainer.text(tourPriceSingle)

    priceCulc = ->
      $('#culc-container').show()
      numOfPeople = Number($('#num-of-people option:selected').text())
      tourPriceBaseCalcedContainer.text(tourPriceBase)
      tourMemberCalcedContainer.text(numOfPeople)
      tourPriceOptionCalcedContainer.text(tourPriceOption)
      tourPriceOptionSingleCalced = tourPriceOptionSingle * numOfPeople
      tourPriceOptionSingleCalcedContainer.text(tourPriceOptionSingleCalced)
      if tourPriceBase + tourPriceOption + tourPriceOptionSingleCalced < 2000
        serviceCostCalced = 500
      else
        serviceCostCalced = Math.ceil((tourPriceBase + tourPriceOption + tourPriceOptionSingleCalced) * 0.145)
      serviceCostCalcedContainer.text(serviceCostCalced)
      tourPriceResultCalcedContainer.text(tourPriceBase + tourPriceOption + tourPriceOptionSingleCalced + serviceCostCalced)
      return

    $('#num-of-people select').on 'change', ->
      priceCulc()
    $('#checkin').on 'changeDate', ->
      priceCulc()

  # listings#show
  if $('body').hasClass('listings show')
    disabled_dates = gon.ngdates
    disabled_weeks = gon.ngweeks

    # open include_what
    $('a.include_what_trigger').on 'click', (e) ->
      $('#include_what').modal()
      e.preventDefault()
      e.stopPropagation()
      return false

    $('a.about_price_trigger').on 'click', ->
      $('#about_price').modal()
      return false

    $('a.include_price_trigger').on 'click', ->
      $('#include_price').modal()
      return false

    #slider
    $('#listing_slider-carousel').sliderPro
      width:'50%'
      height:500
      aspectRatio: 1.5
      visibleSize: '100%'
      forceSize: 'fullWidth'
      arrows: true
      fadeArrows:false
      autoplayDelay:3000
      slideAnimationDuration: 1000
      buttons:false
      keyboard:false
      slideDistance:1
      breakpoints: {
        767: {
          width: '100%'
          height:200
        }
      }
      #waitForLayers: true

    $('#listing_slider-normal').sliderPro
      width:'100%'
      height:427
      arrows: true
      fadeArrows:false
      autoplayDelay:3000
      slideAnimationDuration: 1000
      buttons:false
      breakpoints: {
        767: {
          width: '100%'
          height:200
        }
      }

    # gallery
    $('.sp-slides').magnificPopup
      delegate: '.slider-popup'
      type: 'image'
      gallery:
        enabled: true

    #$('.photo-box').magnificPopup
    #  delegate: '.galon'
    #  type: 'image'
    #  gallery:
    #    enabled: true

    #$('.galon-trigger').on 'click', ->
    #  $('.photo-box').magnificPopup('open')


    # bootstrap datepicker
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'en',
      default: 'yyyy.mm.dd',
      beforeShowDay: (date) ->
        formattedDate = moment(date).format('YYYY.MM.DD')
        if $.inArray(formattedDate.toString(), disabled_dates) != -1
          return { enabled: false }
        if $.inArray(date.getDay(), disabled_weeks) != -1
          return { enabled: false }
        return

    # book_it_button action
    $('#book_it_button').on 'click', ->
      if $('#checkin').val() == ''
        $('#checkin').datepicker('show')
        return false

    # share-via-email modal
    $('#share-via-email-trigger').on 'click', ->
      $('#share-via-email').modal()


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

    ###
    timer = false
    $(window).resize ->
      if timer != false
        clearTimeout timer
      timer = setTimeout((->
         #if videoFlag == true
          #alert 999
        #if(!$('#tour_movie').hasClass('vjs-fullscreen'))
        mediaQueryWidth1()
        return
      ), 200)
      return
    ###

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
        center: new (google.maps.LatLng)(gon.listing.place_latitude, gon.listing.place_longitude)
        # center: new (google.maps.LatLng)(35.319225, 139.546687)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      map = new (google.maps.Map)(document.getElementById('location'), mapOptions)

      marker = new (google.maps.Marker)(
        position:  new (google.maps.LatLng)(gon.listing.place_latitude, gon.listing.place_longitude)
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

  # sp listing manager 1
  if $('.info--sp').length && $('.info--sp').css('display') == "block"
    $('.info--sp').on 'click', ->
      #$('body').addClass('no-scroll')
      $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').show()
      setTimeout (->
        $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').addClass('show-off')
      ), 100
      return false

    # close layer
    $('.close-layer--sp').on 'click', ->
      if $('.manage-listing-nav').css('display') == "block"
        $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').hide()
        $('.manage-listing-nav, .remove-listing-btn, .close-layer--sp').removeClass('show-off')
      else
        $('.manage-listing-detail, .close-layer--sp').hide()
        $('.manage-listing-detail, .close-layer--sp').removeClass('show-off')
      return false

  # sp listing manager 2
  if $('.price--sp').length && $('.price--sp').css('display') == "block"
    $('.price--sp').on 'click', ->
      #$('body').addClass('no-scroll')
      $('.manage-listing-detail, .close-layer--sp').show()
      setTimeout (->
        $('.manage-listing-detail, .close-layer--sp').addClass('show-off')
      ), 100
      return false



  ###
  if $('body').hasClass('listings show')
    array_keywords = gon.keywords
    if array_keywords.length != 0
      keywords = []
      rates = []

      $.each array_keywords, (index, data) ->
        keywords.push data.keyword
        rates.push data.level
        return
      $('#canvas').Radarchart(keywords, rates)
  ###

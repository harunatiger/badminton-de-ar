#listings.coffee
$ ->

  # listings#new
  if $('body').hasClass('listing_details manage') || $('body').hasClass('listing_details update')
    car1 = Number($('#listing_detail_car_rental').val())
    car2 = Number($('#listing_detail_gas').val())
    car3 = Number($('#listing_detail_highway').val())
    car4 = Number($('#listing_detail_parking').val())
    car_cost = car1 + car2 + car3 + car4
    if car_cost == 0
      $('#listing_detail_car_option').prop("checked",false)

    numOfPeople = $('#num-of-people select option')
    # price imitation
    value_calc = ->
      space_check = 0
      car_check = 0
      fvMin = Number($('#listing_detail_min_num_of_people').val())
      fv = Number($('#listing_detail_max_num_of_people').val())
      if numOfPeople == false
        $('#num-of-people select option').remove()
        i = fvMin
        while i <= fv
          $('#num-of-people select').append($('<option value="'+[i]+'">'+[i]+'</option>'));
          i++
      num_of_people = Number($('#sample_num_of_people option:selected').text())
      fv0 = Number($('#listing_detail_time_required').val())
      fv1 = Number($('#listing_detail_price').val())
      fv2 = Number($('#listing_detail_price_for_support').val())
      #fv3 = Number($('#listing_detail_price_for_both_guides').val())
      #fv4 = fv1 + fv2 + fv3
      fv4 = fv1 + fv2
      #if $('#listing_detail_space_option').is(':checked')
      #  fv5 = Number($('#listing_detail_space_rental').val())
      #else
      #  fv5 = 0
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
      #fv10 = fv5 + fv6 + fv7 + fv8 + fv9
      fv10 = fv6 + fv7 + fv8 + fv9
      fv11 = fv4 + fv10
      #fv12 = Math.ceil((fv11) * 0.145)
      #if fv11 <= 500
      #  fv12 = 0
      fv12 = 0
      fv13 = Number($('#listing_detail_guests_cost').val())
      fv14 = fv11 + fv12
      fv15 = $('#listing_detail_included_guests_cost').val()

      if $('#listing_detail_bicycle_option').is(':checked')
        fv16 = Number($('#listing_detail_bicycle_rental').val()) * num_of_people
      else
        fv16 = 0

      if $('#listing_detail_other_option').is(':checked')
        fv17 = Number($('#listing_detail_other_cost').val())
      else
        fv17 = 0

      $('.max-num-of-people').text(fv)
      if fv0 == 24.5
        fv0 = '24h-)'
      else
        fv0 = fv0 + 'h)'
      $('.timelapse').text(fv0)
      $('.guide_price').text(fv4)
      #$('.value_discharge.space_rental').text(fv5)
      $('.value_discharge.car_rental').text(fv6 + fv7 + fv8 + fv9)
      #$('.value_discharge.gas').text(fv7)
      #$('.value_discharge.highway').text(fv8)
      #$('.value_discharge.parking').text(fv9)
      $('.value_discharge.bicycle_rental').text(fv16)
      $('.value_discharge.other_cost').text(fv17)
      $('.value_discharge.option_total').text(fv10 + fv16 + fv17)
      $('.value_discharge.service_fee').text(fv12)
      $('.value_discharge.guests_cost').text(fv13)
      $('.value_discharge.total_price').text(fv14 + fv16 + fv17)

      $('.value_discharge_option').each ->
        if $(this).text() == '0'
          $(this).parent().parent().addClass('hide')
        else
          $(this).parent().parent().removeClass('hide')

      $('#include_what .card-body p').text(fv15)
      $('#max_num_of_people_label').text(fv)

    $('.value_fragile').on 'change', ->
      value_calc()

    $('#sample_num_of_people').on 'change', ->
      numOfPeople = true
      value_calc()

    $('#listing_detail_min_num_of_people').on 'change', ->
      numOfPeople = false
      value_calc()

    $('#listing_detail_max_num_of_people').on 'change', ->
      numOfPeople = false
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

  # listings#search =================
  if $('body').hasClass('search')

    #! auto complete
    initPAC = ->
      inputs = $("input[name='search[location]']")
      options = {
        #types: [ '(cities)' ],
        componentRestrictions: {
          country: "jp"
        }
      }

      autocompletes = new Array()
      inputs.each (index) ->
        autocompletes[index] = new (google.maps.places.Autocomplete)(document.getElementById($(this).attr('id')))
      location_being_changed = undefined

      $.each autocompletes, ->
        google.maps.event.addListener this, 'place_changed', ->
          place = this.getPlace()
          if place.geometry
            inputs.each ->
              $(this).val place.formatted_address
            $('#search_latitude').val place.geometry.location.lat()
            $('#search_longitude').val　place.geometry.location.lng()
            $('#search_form').submit()
          location_being_changed = false
          return

      inputs.keydown (e) ->
        if e.keyCode == 13
          if location_being_changed
            e.preventDefault()
            e.stopPropagation()
        else
          location_being_changed = true
        return

      # sync text box
      inputs.keyup (e) ->
        val = $(this).val()
        inputs.each ->
          $(this).val val
          $('#search_latitude').val ''
          $('#search_longitude').val　''
        return
      return
    #! auto complete activate
    initPAC()

    # category selector show
    $('.category-selected').on 'click', (e) ->
      $('.category-radio').hide()
      $(this).next('.category-radio').show()
      e.preventDefault()

    # category selecting
    $('.category-radio > label').on 'click', (e) ->
      parentContainer = $(this).parents('.category-select')
      radioText = $(this).text()
      radioIcon = $(this).css('background-image')
      parentContainer.find('.category-radio').hide()
      # for back to default value style
      if $(this).hasClass('category-default')
        parentContainer.find('.category-selected').text(radioText).css('background-image', 'none').removeClass('category-selected-icon')
      else
        parentContainer.find('.category-selected').text(radioText).css('background-image', radioIcon).addClass('category-selected-icon')
      return

    # category selector default value setting
    $('.category-select').each ->
      selectedContainer = $(this).find('.category-selected')
      defaultVal = $(this).find('input[type="radio"]:checked').parent()
      defaultValText = defaultVal.text()
      defaultValIcon = defaultVal.css('background-image')
      # for back to default value style
      if defaultVal.hasClass('category-default') || defaultValText == ''
        return
      else
        selectedContainer.text(defaultValText).css('background-image', defaultValIcon).addClass('category-selected-icon')
      return

    # bootstrap datepicker
    $('.datepicker').datepicker
      autoclose: true,
      startDate: '+1d',
      language: 'en',
      orientation: 'top auto'

    # duration range
    if $("#duration-range").val()
      duration_value = $("#duration-range").val().split(',')
      duration_value[0] = parseInt(duration_value[0])
      duration_value[1] = parseInt(duration_value[1])
    else
      duration_value = [2,8]
    $("#duration-range").slider
      min: 1
      max: 24
      step: 1
      range: true
      value: duration_value
      tooltip: 'always'
      tooltip_split: true

    # show filetr
    $('.show-sort-filter').on 'click', (e) ->
      $('.default-buttons').hide()
      $('.sort-filter, .apply-buttons').show()
      if $('#search_sort_by').val() == 'Tour'
        $(".sort-filter a[class='tour_tab']").tab('show')
      else if $('#search_sort_by').val() == 'Spot'
        $(".sort-filter a[class='spot_tab']").tab('show')
      e.preventDefault()

    # reset filetr
    $('.cancel-filter').on 'click', (e) ->
      # sp
      if $('.filters').css('position') == 'fixed'
        $('.filters').hide()
      # pc
      else
        $('.default-buttons').show()
        $('.sort-filter, .apply-buttons').hide()
        $('#tab-spot, #tab-tour').removeClass('active')
        $('.sort-filter li').removeClass('active')

      # clear search params
      $('#search_sort_by').val ''
      $('#search_spot_category').val ''
      $("input[name='search[category1]']").each ->
        $(this).attr('checked', false)
      $("input[name='search[category2]']").each ->
        $(this).attr('checked', false)
      $("input[name='search[category3]']").each ->
        $(this).attr('checked', false)
      $('#search_schedule').val ''
      $('#search_num_of_people').val ''
      $("#duration-range").val ''
      $("input[name*='search[language_ids]']").each ->
        $(this).attr('checked', false)

      # submit tempolary
      $('#search_form').submit()
      e.preventDefault()
      return false

    # sp sort-tab toggle
    $('.sort-filter a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
      if $('.filters').css('position') == 'fixed'
        $('.apply-buttons').show()
      return

    # sp filter show/hide
    $('.js-small-filter-show').on 'click', (e) ->
      $('.filters').show()
      # clear duration range
      $('#duration-range').val ''

      if $('#search_sort_by').val() == 'Tour'
        $(".sort-filter a[class='tour_tab']").tab('show')
      else if $('#search_sort_by').val() == 'Spot'
        $(".sort-filter a[class='spot_tab']").tab('show')
      e.preventDefault()
    $('.js-small-filters-close').on 'click', (e) ->
      $('.filters').hide()
      e.preventDefault()

    # search result map
    initialize = ->
      if gon.locations.length != 0
        bounds = new google.maps.LatLngBounds()
        mapOptions =
          scrollwheel: false
          zoom: 13
          center: new (google.maps.LatLng)(gon.locations[0].latitude, gon.locations[0].longitude)
          mapTypeId: google.maps.MapTypeId.TERRAIN

        map = new (google.maps.Map)(document.getElementById('map'), mapOptions)

        # Multiple Markers
        # Info Window Content
        markers = new Array()
        infoWindowContent = new Array()
        gon.locations.map (l) ->
          tmp_marker = new Array()
          tmp_info = new Array()
          tmp_marker.push(l.title, l.latitude, l.longitude)
          markers.push(tmp_marker)
#           tmp_info.push('<div class="info_content"><img src="' + l.cover_image.thumb.url + '"><h3>' + l.title + '</h3><p>' + l.description  + '</p></div>')
#           infoWindowContent.push(tmp_info)

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

    google.maps.event.addDomListener window, 'load', initialize

    #set hidden_feild
    $(document).on 'click', "a[data-toggle='tab']", ->
      $('#search_sort_by').val $(this).text()
      return

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

  if $('body').hasClass('listings show') || $('body').hasClass('listing_details manage') || $('body').hasClass('listings preview')

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

    $('#reservation_num_of_people').on 'change', ->
      numOfPeople = Number($('#reservation_num_of_people option:selected').text())

      basicPrice = Number($('#reservation_price').val()) + Number($('#reservation_price_for_support').val())
      bycycleCost = Number($('#reservation_bicycle_rental').val()) * numOfPeople
      carCost = Number($('#reservation_car_rental').val()) + Number($('#reservation_gas').val()) + Number($('#reservation_highway').val()) + Number($('#reservation_parking').val())
      otherCost = Number($('#reservation_other_cost').val())
      optionAmount = carCost + bycycleCost + otherCost
      basicPrice = basicPrice + optionAmount
      $('#tour-option-bicycle').text('¥' + bycycleCost)
      $('#tour-option-amount').text('¥' + optionAmount)
      $('#tour-basic-amount').text(basicPrice)

    $('#request--sp').on 'click', ->
      $('#tour-action').show()

    $('.modal-close-request-booking').on 'click', ->
      $('#tour-action').hide()

  # preview edit bar
  if $('body').hasClass('listings preview')
    if $('.header--sp').css('display') == 'none'
      $(window).scroll ->
        scrollTop = $(window).scrollTop()
        if scrollTop == 0
          $('.preview_link').css('top', 50)
        else if scrollTop < 50
          $('.preview_link').css('top', 50 - scrollTop)
        else
          $('.preview_link').css('top', 0)

  # listings#show
  if $('body').hasClass('listings show') || $('body').hasClass('listings preview')
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
      image:
        verticalFit: true
        titleSrc: (item) ->
          if item.el.attr('data-source') != '' || item.el.attr('title') != ''
            item.el.attr('title') + '<span class="category-img" style="background-image: url(' + item.el.attr('data-source') + ')"></span>'
          else
            item.el.attr('title')
      gallery:
        enabled: true
      callbacks:
        markupParse: (template, values, item) ->
          if values.title == ''
            template.removeClass('separate-temprate')
          else
            template.addClass('separate-temprate')

    # review gallery
    $('.review-content').magnificPopup
      delegate: '.review-pic'
      type: 'image'
      image:
        verticalFit: true
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
    $('.datepicker')
      .datepicker
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
      .on 'show', (e) ->
        $('#checkin').blur()
        backdrop = '<div class="datepicker-backdrop"></div>'
        if !$('.datepicker-backdrop').length
          $('.datepicker-dropdown').before(backdrop)
      .on 'hide', (e) ->
        setTimeout (->
          $('.datepicker-backdrop').remove()
        ), 200
        return false

    # for touch devices
    if $('html').hasClass('touch')
      $('.datepicker').attr('readonly', 'readonly')
      $('.datepicker').on 'touchstart', (e) ->
        $(this).datepicker('show')
        e.preventDefault()
      $('.js-checkin-label').on 'touchstart', (e) ->
        e.preventDefault()

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
      tourMovie = $('#tour-movie')
      tourMovieContainer = $('#tour-movie-container')
      reviewBlock = $('#review-block')
      reviewBlockContainer = $('#review-block-container')
      reviewBlockContainerSp = $('#review-block-container--sp')
      announcementBanner = $('#announcement-banner')
      announcementContainer = $('#announcement-banner-container')
      announcementContainerSp = $('#announcement-banner-container--sp')


      if($('.col-left').css('float') == "left")
        # evacuate fullscreen movie
        if(!tourMovie.hasClass('vjs-fullscreen'))
          tourMovie.appendTo(tourMovieContainer)
          announcementBanner.appendTo(announcementContainer)
          reviewBlock.appendTo(reviewBlockContainer)
      else
        # evacuate fullscreen movie
        if(!tourMovie.hasClass('vjs-fullscreen'))
          tourMovie.insertBefore(listingDescription)
          announcementBanner.appendTo(announcementContainerSp)
          reviewBlock.appendTo(reviewBlockContainerSp)

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
        $('.manage-listing-nav, .close-layer--sp').hide()
        $('.manage-listing-nav, .close-layer--sp').removeClass('show-off')
      return false

  # sp listing manager 2
  if $('.price--sp').length && $('.price--sp').css('display') == "block"
    $('.price--sp').on 'click', ->
      #$('body').addClass('no-scroll')
      $('.manage-listing-help-panel').css('position', 'relative')
      $('#tour-action-preview').css('position', 'relative')
      $('.manage-listing-help-panel').css('top', '0')
      $('#tour-action-preview').css('top', '0')
      $('.manage-listing-help-panel').css('margin-top', '20px')
      $('#tour-action-preview').css('margin-top', '20px')
      $('.manage-listing-help-panel').css('width', 'auto')
      $('#tour-action-preview').css('width', 'auto')

      $('.manage-listing-detail, .close-layer--sp').show()
      setTimeout (->
        $('.manage-listing-detail, .close-layer--sp').addClass('show-off')
      ), 100
      return false
    # close layer
    $('.close-layer--sp').on 'click', ->
      if $('.manage-listing-detail').css('display') == "block"
        $('.manage-listing-detail, .remove-listing-btn, .close-layer--sp').hide()
        $('.manage-listing-detail, .remove-listing-btn, .close-layer--sp').removeClass('show-off')
      else
        $('.manage-listing-detail, .close-layer--sp').hide()
        $('.manage-listing-detail, .close-layer--sp').removeClass('show-off')
      return false

  # sp listing manager 3
  if $('.edit-help--sp').length && $('.edit-help--sp').css('display') == "block"
    $('.edit-help--sp').on 'click', ->
      $('.manage-listing-help-panel').css('position', 'relative')
      $('.manage-listing-help-panel').css('top', '0')
      $('.manage-listing-help-panel').css('margin-top', '20px')
      $('.manage-listing-help-panel').css('width', 'auto')
      $('.manage-listing-edit, .close-layer--sp').show()
      setTimeout (->
        $('.manage-listing-edit, .close-layer--sp').addClass('show-off')
      ), 100
      return false
  # close layer
    $('.close-layer--sp').on 'click', ->
      if $('.manage-listing-edit').css('display') == "block"
        $('.manage-listing-edit, .remove-listing-btn, .close-layer--sp').hide()
        $('.manage-listing-edit, .remove-listing-btn, .close-layer--sp').removeClass('show-off')
      else
        $('.manage-listing-edit, .close-layer--sp').hide()
        $('.manage-listing-edit, .close-layer--sp').removeClass('show-off')
      return false

  if $('body').hasClass('listings new') || $('body').hasClass('listings edit') || $('body').hasClass('listings create') || $('body').hasClass('listings update')

    #---------------------------------------------------------------------
    # SearchBox Enterkey controll
    #---------------------------------------------------------------------
    $('#listing_listing_destination_location').keypress (e) ->
      if (e.which == 13)
        $('#listing_notes').focus()
        e.preventDefault()

    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------

    map = null
    markers = new Array()
    locations = $("input[name*='listing_destinations_attributes'][name*='location']")
    autocompletes = new Array()
    locations.each (index) ->
      autocompletes[index] = new (google.maps.places.Autocomplete)(document.getElementById($(this).attr('id')))
    geocoder = new (google.maps.Geocoder)
    show = true

    #---------------------------------------------------------------------
    # Create MapCanvas
    #---------------------------------------------------------------------

    initialize = ->
      mark_count = 0
      bounds = new google.maps.LatLngBounds()
      locations.each (index) ->
        if $(this).val() != null && $(this).val() != ''
          lat_element = $("input[name*='listing_destinations_attributes'][name*='latitude']").eq(index)
          lng_element = $("input[name*='listing_destinations_attributes'][name*='longitude']").eq(index)
          lat =  document.getElementById(lat_element.attr('id')).value
          lng =  document.getElementById(lng_element.attr('id')).value
          if lat && lng
            mark_count += 1
            latlng = new google.maps.LatLng(lat,lng)
            mapOptions =
              center: latlng
              zoom: 17
              mapTypeId: google.maps.MapTypeId.ROADMAP
            if map == null
              map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
            markers[index] = new (google.maps.Marker)(
              map: map
              position: latlng
              anchorPoint: new google.maps.Point(0,-24)
              draggable: true)
            bounds.extend markers[index].position

            show = true
            google.maps.event.addListener markers[index], 'dragend', (e) ->
              geocodeLatLng e.latLng.lat(), e.latLng.lng(), index
              return

        text = ''
        $(this).focus ->
          text = $(this).val()
        $(this).blur ->
          if text != $(this).val()
            deleteMark(index)

      if map
        setBounds()

      if mark_count == 0
        $('#map').parents('#map-wrapper').slideUp()
        $('#map').parents('#map-wrapper').removeClass('in')
        show = false
      else
        $('#map').parents('#map-wrapper').slideDown()
        $('#map').parents('#map-wrapper').addClass('in')
        $('#map').css 'height', '300px'
        show = true

    google.maps.event.addDomListener window, 'load', initialize

    #---------------------------------------------------------------------
    # geocoding from LatLng
    #---------------------------------------------------------------------

    geocodeLatLng = (lat, lng, index) ->
      latlng = new (google.maps.LatLng)(lat, lng)
      geocoder.geocode { 'latLng': latlng }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          if results[1]
            $("input[name*='listing_destinations_attributes'][name*='latitude']").eq(index).val results[0].geometry.location.lat()
            $("input[name*='listing_destinations_attributes'][name*='longitude']").eq(index).val results[0].geometry.location.lng()
            $("input[name*='listing_destinations_attributes'][name*='location']").eq(index).val results[0].formatted_address
        return
      return

    #---------------------------------------------------------------------
    # Set Bounds
    #---------------------------------------------------------------------
    setBounds = ->
      bounds = new google.maps.LatLngBounds()
      $.each locations, (i) ->
        if markers[i] && markers[i].map != null
          bounds.extend markers[i].position
      map.fitBounds bounds
      listener = google.maps.event.addListener(map, 'idle', ->
        if map.getZoom() > 17
          map.setZoom 17
        google.maps.event.removeListener listener
        return
      )

    #---------------------------------------------------------------------
    # delete mark
    #---------------------------------------------------------------------
    deleteMark = (index) ->
      $("input[name*='listing_destinations_attributes'][name*='latitude']").eq(index).val ''
      $("input[name*='listing_destinations_attributes'][name*='longitude']").eq(index).val ''

      if markers[index]
        markers[index].setMap(null)
        setBounds()

      all_empty = true
      $.each locations, (i) ->
        if markers[i] && markers[i].map != null
          all_empty = false
          return

      if all_empty
        $('#map').parents('#map-wrapper').slideUp()
        $('#map').parents('#map-wrapper').removeClass('in')
        show = false
      return

    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autoComplete = ->
      $.each autocompletes, (index) ->
        this.addListener 'place_changed', ->
          place = this.getPlace()
          if !place.geometry
            $("input[name*='listing_destinations_attributes'][name*='latitude']").eq(index).empty()
            $("input[name*='listing_destinations_attributes'][name*='longitude']").eq(index).empty()
            if show == true
              $('#map').parents('#map-wrapper').slideUp()
              show = false
            return

          $('#map').parents('#map-wrapper').slideDown()
          $('#map').css 'height', '300px'
          show = true

          if !map
            mapOptions =
              center: place.geometry.location
              zoom: 17
              mapTypeId: google.maps.MapTypeId.ROADMAP
            map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
          if markers[index]
            markers[index].setMap map
            markers[index].setPosition place.geometry.location
            markers[index].setVisible true
          else
            markers[index] = new (google.maps.Marker)(
              map: map
              position: place.geometry.location
              draggable: true)

          setBounds()
          $("input[name*='listing_destinations_attributes'][name*='latitude']").eq(index).val place.geometry.location.lat()
          $("input[name*='listing_destinations_attributes'][name*='longitude']").eq(index).val place.geometry.location.lng()
          $("input[name*='listing_destinations_attributes'][name*='location']").eq(index).val place.name + ', ' +place.formatted_address

          google.maps.event.addListener markers[index], 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng(), index
      return

    autoComplete()

    $(document).on 'click', '.add_nested_fields', ->
      $.each locations, (i) ->
        if markers[i] && markers[i].map != null
          markers[i].setMap(null)
      markers = new Array()
      autocompletes = new Array()
      locations = $("input[name*='listing_destinations_attributes'][name*='location']")
      locations.each (index) ->
        autocompletes[index] = new (google.maps.places.Autocomplete)(document.getElementById($(this).attr('id')))
      initialize()
      autoComplete()
      return

    $(document).on 'click', '.remove_nested_fields', ->
      index = $('.remove_nested_fields').index(this)
      deleteMark(index)

      $.each locations, (i) ->
        if markers[i] && markers[i].map != null
          markers[i].setMap(null)
      markers = new Array()
      autocompletes = new Array()
      locations = $("input[name*='listing_destinations_attributes'][name*='location']")
      locations.each (index) ->
        autocompletes[index] = new (google.maps.places.Autocomplete)(document.getElementById($(this).attr('id')))
      initialize()
      autoComplete()
      return

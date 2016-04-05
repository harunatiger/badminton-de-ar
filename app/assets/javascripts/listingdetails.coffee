# listing_details#manage
$ ->
  helpScrollEdit = ->
    titleTop = $('#tour-title').offset().top
    overviewTop = $('#tour-overview').offset().top
    notesTop = $('#tour-notes').offset().top
    conditionTop = $('#tour-condition').offset().top
    titleHeight = $('#tour-title').outerHeight(true)
    overviewHeight = $('#tour-overview').outerHeight(true)
    notesHeight = $('#tour-notes').outerHeight(true)
    conditionHeight = $('#tour-condition').outerHeight(true)
    headerHeight = $('#header').outerHeight(true)
    subnavHeight = $('.subnav').outerHeight(true)

    titleHelp = $('.listing_help_block #tour-title-help')
    overviewHelp = $('.listing_help_block #tour-overview-help')
    notesHelp = $('.listing_help_block #tour-notes-help')
    conditionHelp = $('.listing_help_block #tour-condition-help')

    titleHelp.css('top', titleTop - headerHeight - subnavHeight - 50 + 'px')
    overviewHelp.css('top', overviewTop - headerHeight - subnavHeight + 50 + 'px')
    if $('#map-wrapper').hasClass('in')
      notesHelp.css('top', notesTop - headerHeight - subnavHeight + 'px')
      conditionHelp.css('top', conditionTop - headerHeight - subnavHeight + 'px')
    else
      notesHelp.css('top', (notesTop - headerHeight - subnavHeight) - 500 + 'px')
      conditionHelp.css('top', (conditionTop - headerHeight - subnavHeight) - 500 + 'px')

  helpScrollManage = ->
    previewHelp = $('.request-block #tour-preview-help')
    actionHelp = $('.request-block #tour-action-preview')
    peopleHelp = $('.request-block #tour-people-help')
    guidefeeHelp = $('.request-block #tour-guidefee-help')
    optionfeeHelp = $('.request-block #tour-optionfee-help')

    previewHeight = $('.request-block #tour-preview-help').outerHeight(true)
    actionHeight = $('.request-block #tour-action-preview').outerHeight(true)
    peopleHeight = $('.request-block #tour-people-help').outerHeight(true)
    guidefeeHeight = $('.request-block #tour-guidefee-help').outerHeight(true)

    previewHelp.css('top', '40px')
    actionHelp.css('top', previewHeight + 40 + 'px')
    peopleHelp.css('top', previewHeight + actionHeight + 120 + 'px')
    guidefeeHelp.css('top', previewHeight + actionHeight + peopleHeight + 120 + 'px')
    optionfeeHelp.css('top', previewHeight + actionHeight + peopleHeight + guidefeeHeight + 120 + 'px')

  if $('body').hasClass('listings edit') ||  $('body').hasClass('listings new') || $('body').hasClass('listings create')
    $elementReference = document.getElementById( "listing_notes" )
    $placeholder = '例）山道を歩くので、スニーカーなど動きやすい靴や動きやすい格好でお越しください。' + "\n" + '例）肉料理が出るので、ベジタリアンの方はあらかじめご連絡ください。'
    $elementReference.placeholder = $placeholder

    $('.listing-manager-area-container').text('')
    areas = []
    $('[name="listing[pickup_ids][]"]:checked').each ->
      areas.push $(this).parent().text()
    if areas.length > 0
      $('.listing-manager-area-container').text('')
      $.each areas, (index, elem) ->
        $('.listing-manager-area-container').append('<span class="listing-area-item">' + elem + '</span>')


    #---------------------------------------------------------------------
    # open listing_area
    #---------------------------------------------------------------------
    $('.listing-manager-area').on 'click', (e) ->
      $('#listing_area').modal()
      e.preventDefault()
      e.stopPropagation()
      return false

    $('.listing-manager-area-submit').on 'click', (e) ->
      $('.listing-manager-area-container').text('')
      areas = []
      $('[name="listing[pickup_ids][]"]:checked').each ->
        areas.push $(this).parent().text()
      if areas.length > 0
        $('.listing-manager-area-container').text('')
        $.each areas, (index, elem) ->
          $('.listing-manager-area-container').append('<span class="listing-area-item">' + elem + '</span>')
      $('#listing_area').modal('hide')

    #---------------------------------------------------------------------
    # SearchBox Enterkey controll
    #---------------------------------------------------------------------
    $('#listing_listing_detail_attributes_place').keypress (e) ->
      if (e.which == 13)
        $('#listing_listing_detail_attributes_place_memo').focus()
        e.preventDefault()
    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------
    map = null
    marker = null
    location = document.getElementById('listing_listing_detail_attributes_place')
    autocomplete = new (google.maps.places.Autocomplete)(location)
    geocoder = new (google.maps.Geocoder)
    show = true
    #---------------------------------------------------------------------
    # Create MapCanvas
    #---------------------------------------------------------------------
    initialize = ->
      if location.value != null && location.value != ''
        lat =  document.getElementById('listing_listing_detail_attributes_place_latitude').value
        lng =  document.getElementById('listing_listing_detail_attributes_place_longitude').value
        if lat && lng
          latlng = new google.maps.LatLng(lat,lng)
          mapOptions =
            center: latlng
            zoom: 17
            mapTypeId: google.maps.MapTypeId.ROADMAP
          map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
          marker = new (google.maps.Marker)(
            map: map
            position: latlng
            anchorPoint: new google.maps.Point(0,-24)
            draggable: true)
          $('#map').parents('.row').slideDown()
          $('#map').parents('.row').addClass('in')
          $('#map').css 'height', '300px'
          autocomplete.bindTo 'bounds', map
          show = true
          google.maps.event.addListener marker, 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng()
            return
        else
          $('#map').parents('.row').slideUp()
          $('#map').parents('.row').removeClass('in')
          show = false
      else
        $('#map').parents('.row').slideUp()
        $('#map').parents('.row').removeClass('in')
        show = false

      helpScrollEdit()

      ###
      address = document.getElementById('listing_detail_place').value
      geocoder.geocode { 'address': address }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          mapOptions =
            center: results[0].geometry.location
            zoom: 17
            mapTypeId: google.maps.MapTypeId.ROADMAP
          map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
          marker = new (google.maps.Marker)(
            map: map
            position: results[0].geometry.location
            anchorPoint: new google.maps.Point(0,-24)
            draggable: true)
          $('#map').parents('.row').slideDown()
          $('#map').css 'height', '300px'
          autocomplete.bindTo 'bounds', map
          show = true
          google.maps.event.addListener marker, 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng()
            return
        else
          $('#map').parents('.row').slideUp()
          show = false
        return
      ###
      $('#listing_listing_detail_attributes_place').blur ->
        if jQuery.trim($(this).val()) == ''
          $('#listing_listing_detail_attributes_place_latitude').val 0.0
          $('#listing_listing_detail_attributes_place_longitude').val 0.0
          $('#map').parents('.row').slideUp()
          $('#map').parents('.row').removeClass('in')
          show = false
        return
      return
    google.maps.event.addDomListener window, 'load', initialize
    #---------------------------------------------------------------------
    # geocoding from LatLng
    #---------------------------------------------------------------------
    geocodeLatLng = (lat, lng) ->
      latlng = new (google.maps.LatLng)(lat, lng)
      geocoder.geocode { 'latLng': latlng }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          if results[1]
            $('#listing_listing_detail_attributes_place_latitude').val results[0].geometry.location.lat()
            $('#listing_listing_detail_attributes_place_longitude').val results[0].geometry.location.lng()
            $('#listing_listing_detail_attributes__place').val results[0].formatted_address
        return
      return
    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autocomplete.addListener 'place_changed', ->
      place = autocomplete.getPlace()
      if !place.geometry
        $('#listing_listing_detail_attributes_place_latitude').empty()
        $('#listing_listing_detail_attributes_place_longitude').empty()
        if show = true
          $('#map').parents('.row').slideUp()
          show = false
        return
      $('#map').parents('.row').slideDown()
      $('#map').css 'height', '300px'
      show = true
      if map
        if place.geometry.viewport
          map.fitBounds place.geometry.viewport
        else
          map.setCenter place.geometry.location
          map.setZoom 17
      else
        mapOptions =
          center: place.geometry.location
          zoom: 17
          mapTypeId: google.maps.MapTypeId.ROADMAP
        map = new (google.maps.Map)(document.getElementById('map'), mapOptions)
      if marker
        marker.setVisible false
        marker.setPosition place.geometry.location
        marker.setVisible true
      else
        marker = new (google.maps.Marker)(
          map: map
          position: place.geometry.location
          draggable: true)
      $('#listing_listing_detail_attributes_place_latitude').val place.geometry.location.lat()
      $('#listing_listing_detail_attributes_place_longitude').val place.geometry.location.lng()
      $('#listing_listing_detail_attributes_place').val place.name + ', ' +place.formatted_address
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    return


  if $('body').hasClass('listing_details manage') || $('body').hasClass('listing_details update')

    helpScrollManage()

    #---------------------------------------------------------------------
    # open include_what
    #---------------------------------------------------------------------
    $('a.include_what_trigger_ja').on 'click', (e) ->
      $('#include_what_ja').modal()
      e.preventDefault()
      e.stopPropagation()
      return false



  $('.calendar-description').on 'click', (e) ->
    if $(this).parents('.collapse-panel').hasClass('active')
      $(this).parents('.collapse-heading').next().collapse('hide')
      $(this).parents('.collapse-panel').removeClass('active')
      $(this).find('i.fa-caret-up').addClass('fa-caret-down')
      $(this).find('i.fa-caret-up').removeClass('fa-caret-up')
    else
      $(this).parents('.collapse-heading').next().collapse('show')
      $(this).parents('.collapse-panel').addClass('active')
      $(this).find('i.fa-caret-down').addClass('fa-caret-up')
      $(this).find('i.fa-caret-down').removeClass('fa-caret-down')

#calc price
$ ->
  price = Number($('#listing_detail_price').val())
  price_other = Number($('#listing_detail_price_other').val())
  price_calced = $('#price_calced')
  price_calced.text('¥' + (price + price_other))
  $(document).on 'change', '#listing_detail_price', ->
    price = Number($('#listing_detail_price').val())
    price_calced.text('¥' + (price_other + price))

  $(document).on 'change', '#listing_detail_price_other', ->
    price_other = Number($('#listing_detail_price_other').val())
    price_calced.text('¥' + (price + price_other))

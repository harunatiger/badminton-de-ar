$ ->
  if $('body').hasClass('spots new') || $('body').hasClass('spots edit') || $('body').hasClass('spots create') || $('body').hasClass('spots update')

    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------
    $(document).on 'click', '.select_spot_category', ->
      if $(this).hasClass('listing_image_selected')
        $(this).removeClass('listing_image_selected')
        $(this).children("i").remove()
        $('#spot_pickup_id').val($(this).attr(''))
      else
        $('.select_spot_category').each (index) ->
          $(this).children("i").remove()
          $(this).removeClass('listing_image_selected')

        $(this).addClass('listing_image_selected')
        $(this).append("<i class='fa fa-check'></i>")
        $('#spot_pickup_id').val($(this).attr('pickup_id'))
      return false

    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------
    map = null
    marker = null
    location = document.getElementById('spot_location')
    autocomplete = new (google.maps.places.Autocomplete)(location)
    geocoder = new (google.maps.Geocoder)
    show = true
    location_value = $('#spot_location').val()
    #---------------------------------------------------------------------
    # Create MapCanvas
    #---------------------------------------------------------------------
    initialize = ->
      if location.value != null && location.value != ''
        lat =  $('#spot_latitude').val()
        lng =  $('#spot_longitude').val()
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
          $('#map').parents('#map-wrapper').slideDown()
          $('#map').parents('#map-wrapper').addClass('in')
          $('#map').css 'height', '300px'
          autocomplete.bindTo 'bounds', map
          show = true
          google.maps.event.addListener marker, 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng()
            return
        else
          $('#map').parents('#map-wrapper').slideUp()
          $('#map').parents('#map-wrapper').removeClass('in')
          show = false
      else
        $('#map').parents('#map-wrapper').slideUp()
        $('#map').parents('#map-wrapper').removeClass('in')
        show = false
      
      $('#spot_location').keydown (e) ->
        if e.keyCode == 13
          e.preventDefault()
          e.stopPropagation()
        return
      
      $('#spot_location').keyup (e) ->
        if location_value != $(this).val()
          $('#spot_latitude').val ''
          $('#spot_longitude').val ''
          $('#map').parents('#map-wrapper').slideUp()
          $('#map').parents('#map-wrapper').removeClass('in')
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
            $('#spot_latitude').val results[0].geometry.location.lat()
            $('#spot_longitude').val results[0].geometry.location.lng()
            $('#spot_location').val results[0].formatted_address
        return
      return
    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autocomplete.addListener 'place_changed', ->
      if location_value == $('#spot_location').val()
        return
      
      place = autocomplete.getPlace()
      if !place.geometry
        $('#spot_latitude').empty()
        $('#spot_longitude').empty()
        if show = true
          $('#map').parents('#map-wrapper').slideUp()
          show = false
        return
      $('#map').parents('#map-wrapper').slideDown()
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
      $('#spot_latitude').val place.geometry.location.lat()
      $('#spot_longitude').val place.geometry.location.lng()
      $('#spot_location').val place.name + ', ' +place.formatted_address
      location_value = $('#spot_location').val()
      
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    
    #---------------------------------------------------------------------
    # area setting
    #---------------------------------------------------------------------
    $('.listing-manager-area-container').text('')
    areas = []
    $('[name="spot[pickup_ids][]"]:checked').each ->
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
      $('[name="spot[pickup_ids][]"]:checked').each ->
        areas.push $(this).parent().text()
      if areas.length > 0
        $('.listing-manager-area-container').text('')
        $.each areas, (index, elem) ->
          $('.listing-manager-area-container').append('<span class="listing-area-item">' + elem + '</span>')
      $('#listing_area').modal('hide')

  if $('body').hasClass('spots show')
    # show location
    initialize = ->
      mapOptions =
        scrollwheel: false
        zoom: 13
        center: new (google.maps.LatLng)(gon.spot.latitude, gon.spot.longitude)
        # center: new (google.maps.LatLng)(35.319225, 139.546687)
        mapTypeId: google.maps.MapTypeId.TERRAIN

      map = new (google.maps.Map)(document.getElementById('location'), mapOptions)

      marker = new (google.maps.Marker)(
        position:  new (google.maps.LatLng)(gon.spot.latitude, gon.spot.longitude)
        map: map
        icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FFD000')
      return

    google.maps.event.addDomListener window, 'load', initialize

  # spots detail
  if $('body').hasClass('spots show')

    # Back button effect
    ###
    ans = undefined
    bs = false
    ref = document.referrer
    domain = location.hostname
    $(window).on 'unload beforeunload', ->
      bs = true
      return
    re = new RegExp("^https?:\/\/" + domain, "i")
    if ref.match(re)
      ans = true
    else
      ans = false
    $('.back-link').on 'click', (e) ->
      that = this
      if ans
        history.back()
        setTimeout (->
          if !bs
            location.href = $(that).attr('href')
          return
        ), 100
      else
        location.href = $(this).attr('href')
      e.preventDefault()
    ###

  # social-share-widget
  if('.social-share-widget').length
    # facebook share
    $('.share-facebook-btn').on 'click', ->
      window.open('https://www.facebook.com/sharer/sharer.php?u='+encodeURIComponent(window.location.href), 'facebook-share-dialog', 'width=626, height=436, personalbar=0, toolbar=0, scrollbars=1, resizable=!')
      return false
    # twitter share
    $('.share-twitter-btn').on 'click', ->
      window.open('http://twitter.com/intent/tweet?text=' + 'Spot' + '&amp;url=' + encodeURIComponent(window.location.href) + '&amp;via=' + 'Huber.', 'tweetwindow', 'width=550, height=450, personalbar=0, toolbar=0, scrollbars=1, resizable=1')
      return false
    # line share
    $('.sns-line-btn').on 'click', ->
      window.location = 'http://line.me/R/msg/text/?' + 'Recommend' + encodeURIComponent(window.location.href)
      return false
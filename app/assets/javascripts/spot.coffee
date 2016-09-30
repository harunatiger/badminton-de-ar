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

      $('#spot_location').blur ->
        if jQuery.trim($(this).val()) == ''
          $('#spot_latitude').val 0.0
          $('#spot_longitude').val 0.0
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
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    return

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
        map: map )
      return

    google.maps.event.addDomListener window, 'load', initialize

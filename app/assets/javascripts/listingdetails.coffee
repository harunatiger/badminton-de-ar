# listing_details#manage
$ ->
  if $('body').hasClass('listing_details manage')
    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------
    map = null
    marker = null
    location = document.getElementById('listing_detail_place')
    autocomplete = new (google.maps.places.Autocomplete)(location)
    geocoder = new (google.maps.Geocoder)
    show = true
    #---------------------------------------------------------------------
    # Create MapCanvas
    #---------------------------------------------------------------------
    initialize = ->
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
      $('#listing_detail_place').blur ->
        if jQuery.trim($(this).val()) == ''
          $('#map').parents('.row').slideUp()
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
            $('#listing_detail_place').val results[0].formatted_address
        return
      return

    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autocomplete.addListener 'place_changed', ->
      place = autocomplete.getPlace()
      if !place.geometry
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
      $('#listing_detail_place').val place.formatted_address
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    return

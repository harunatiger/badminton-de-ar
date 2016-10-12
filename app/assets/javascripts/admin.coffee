$ ->
  # set location for listing_destination
  if $('body').hasClass('new admin_listing_destinations') || $('body').hasClass('edit admin_listing_destinations') || $('body').hasClass('create admin_listing_destinations') || $('body').hasClass('update admin_listing_destinations')
    
    #---------------------------------------------------------------------
    # GoogleMap for Place
    #---------------------------------------------------------------------
    map = null
    marker = null
    location = document.getElementById('listing_destination_location')
    autocomplete = new (google.maps.places.Autocomplete)(location)
    geocoder = new (google.maps.Geocoder)
    show = true
    location_value = $('#listing_destination_location').val()
    $('#listing_destination_longitude').after("<div id='map' style='margin: 20px 100px;'></div>")
    #---------------------------------------------------------------------
    # Create MapCanvas
    #---------------------------------------------------------------------
    initialize = ->
      if location.value != null && location.value != ''
        lat =  $('#listing_destination_latitude').val()
        lng =  $('#listing_destination_longitude').val()
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
          $('#map').css 'height', '300px'
          autocomplete.bindTo 'bounds', map
          show = true
          google.maps.event.addListener marker, 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng()
            return
        else
          show = false
      else
        show = false
      
      $('#listing_destination_location').keydown (e) ->
        if e.keyCode == 13
          e.preventDefault()
          e.stopPropagation()
        return
      
      $('#listing_destination_location').keyup (e) ->
        if location_value != $(this).val()
          $('#listing_destination_latitude').val ''
          $('#listing_destination_longitude').val ''
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
            $('#listing_destination_latitude').val results[0].geometry.location.lat()
            $('#listing_destination_longitude').val results[0].geometry.location.lng()
            $('#listing_destination_location').val results[0].formatted_address
        return
      return
    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autocomplete.addListener 'place_changed', ->
      if location_value == $('#listing_destination_location').val()
        return
      
      place = autocomplete.getPlace()
      if !place.geometry
        $('#listing_destination_latitude').empty()
        $('#listing_destination_longitude').empty()
        if show = true
          show = false
        return
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
      $('#listing_destination_latitude').val place.geometry.location.lat()
      $('#listing_destination_longitude').val place.geometry.location.lng()
      $('#listing_destination_location').val place.name + ', ' +place.formatted_address
      location_value = $('#listing_destination_location').val()
      
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    return
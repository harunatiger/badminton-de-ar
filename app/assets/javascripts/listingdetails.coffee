# listing_details#manage
$ ->
  if $('body').hasClass('listing_details manage')
    #---------------------------------------------------------------------
    # SearchBox Enterkey controll
    #---------------------------------------------------------------------
    $('#listing_detail_place').keypress (e) ->
      if (e.which == 13)
        $('#listing_detail_place_memo').focus()
        e.preventDefault()
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
      if location.value != null && location.value != ''
        lat =  document.getElementById('listing_detail_place_latitude').value
        lng =  document.getElementById('listing_detail_place_longitude').value
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
          $('#map').css 'height', '300px'
          autocomplete.bindTo 'bounds', map
          show = true
          google.maps.event.addListener marker, 'dragend', (e) ->
            geocodeLatLng e.latLng.lat(), e.latLng.lng()
            return
        else
          $('#map').parents('.row').slideUp()
          show = false
      else
        $('#map').parents('.row').slideUp()
        show = false
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
      $('#listing_detail_place').blur ->
        if jQuery.trim($(this).val()) == ''
          $('#listing_detail_place_latitude').val 0.0
          $('#listing_detail_place_longitude').val 0.0
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
            $('#listing_detail_place_latitude').val results[0].geometry.location.lat()
            $('#listing_detail_place_longitude').val results[0].geometry.location.lng()
            $('#listing_detail_place').val results[0].formatted_address
        return
      return
    #---------------------------------------------------------------------
    # Place Change Event
    #---------------------------------------------------------------------
    autocomplete.addListener 'place_changed', ->
      place = autocomplete.getPlace()
      if !place.geometry
        $('#listing_detail_place_latitude').empty()
        $('#listing_detail_place_longitude').empty()
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
      $('#listing_detail_place_latitude').val place.geometry.location.lat()
      $('#listing_detail_place_longitude').val place.geometry.location.lng()
      $('#listing_detail_place').val place.name + ', ' +place.formatted_address
      google.maps.event.addListener marker, 'dragend', (e) ->
        geocodeLatLng e.latLng.lat(), e.latLng.lng()
        return
      return
    return

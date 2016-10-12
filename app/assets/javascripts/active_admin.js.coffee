#= require active_admin/base

# set location for listing_destination
alert 'aaa'
alert $('body').attr('class')
if $('body').hasClass('new admin_listing_destinations') || $('body').hasClass('edit admin_listing_destinations') || $('body').hasClass('create admin_listing_destinations') || $('body').hasClass('update admin_listing_destinations')
  alert 'a'
  input = document.getElementById('listing_destination_location')
  autocomplete = new (google.maps.places.Autocomplete)(input)
  location_being_changed = undefined

  google.maps.event.addListener autocomplete, 'place_changed', ->
    place = this.getPlace()
    if place.geometry
      $('#listing_destination_latitude').val place.geometry.location.lat()
      $('#listing_destination_longitude').val　place.geometry.location.lng()
    location_being_changed = false
    return

#       $('#location-search').keydown (e) ->
#         if e.keyCode == 13
#           if location_being_changed
#             e.preventDefault()
#             e.stopPropagation()
#         else
#           $('#search_form').find('#search_latitude').val ''
#           $('#search_form').find('#search_longitude').val　''
#           location_being_changed = true
#         return
  return
return

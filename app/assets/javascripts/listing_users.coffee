$ ->
  # change authorized user status
  if $('body').hasClass('listing_users index')
    $('#listing_authorized_user_status').on 'change', ->
      $('#edit_listing_1').submit()
      return
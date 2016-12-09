$ ->
  # change authorized user status
  if $('body').hasClass('listing_users index')
    $('#listing_authorized_user_status').on 'change', ->
      $('#edit_listing_1').submit()
      return

    $('.js-modal-about_activity_member-trigger').on 'click', (e) ->
      $('#about_activity_member').modal('show')
      e.preventDefault()

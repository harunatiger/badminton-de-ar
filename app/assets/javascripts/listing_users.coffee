$ ->
  if $('body').hasClass('listing_users index')
    # change authorized user status
    $('#listing_authorized_user_status').on 'change', ->
      $('#edit_listing_1').submit()
      return
      
    # change member status
    $('.js-change-member-status-trigger').on 'change', ->
      if  $(this).val() == '2'
        # remove member
        $(this).nextAll('.js-remove-member-trigger')[0].submit()
      else if  $(this).val() == '1'
        # add receptionist
        $(this).nextAll('.js-add-receptionist-trigger')[0].submit()
      return

    $('.js-modal-about_activity_member-trigger').on 'click', (e) ->
      $('#about_activity_member').modal('show')
      e.preventDefault()

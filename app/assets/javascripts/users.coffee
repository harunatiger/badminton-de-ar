$ ->
  $('.confirm_withdraw_link').on 'click', ->
    $('#confirm_withdraw_guest').modal('hide')
    $('#confirm_withdraw_guide').modal('hide')
    $('#confirm_withdraw').modal()
    return false
  
  $('.confirm_withdraw_guest_link').on 'click', ->
    $('#confirm_withdraw_guest').modal()
    return false
  
  $('.confirm_withdraw_guide_link').on 'click', ->
    $('#confirm_withdraw_guest').modal('hide')
    $('#confirm_withdraw_guide').modal()
    return false
  
  #email empty registration for facebook
  if $('#create_email')
    $('#create_email').modal()
  
  #clear session
  $(document).on 'hidden.bs.modal', '#create_email', ->
    $.ajax(
      type: 'GET'
      url: '/users/clear_auth_session'
    )
    return

  $(document).on 'click', '.email_register', ->
    targetForm = $(this).closest('form')
    spinner = $('.spinner', targetForm)
    spinner.spin('flower', 'white')
    $('.btn-frame > .btn', targetForm).addClass('text-disappear')
    return

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
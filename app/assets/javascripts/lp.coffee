$ ->
  if $('body').hasClass('static_pages plan4U')
    $(document).on 'click', '.sign_up_form', ->
      to_user_id = $(this).attr('user_id')
      if to_user_id
        $("#sns_button").attr("href", "/users/before_omniauth?to_user_id=" + to_user_id)
        $("#new_user").attr("action", "/users?to_user_id=" + to_user_id)
        $('#sign_up_form').modal()
      return false
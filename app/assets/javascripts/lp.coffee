$ ->
  if $('body').hasClass('static_pages lp01')
    $(document).on 'click', '.sign_up_form', ->
      to_user_id = $(this).attr('user_id')
      if to_user_id
        $("#sns_button").attr("href", "/users/before_omniauth?to_user_id=" + to_user_id)
        $("#new_user").attr("action", "/users?to_user_id=" + to_user_id)
        $('#sign_up_form').modal()
      #  $.ajax(
      #    type: 'GET'
      #    url: '/static_pages/sign_up_form'
      #    data: {
      #      to_user_id: to_user_id
      #    }
      #  ).done (data) ->
      #    $('#sign_up_form').html(data)
      #    $('#sign_up_form').modal('show')
      return false
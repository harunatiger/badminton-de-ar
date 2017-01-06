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
    
  if $('body').hasClass('registrations new') || $('body').hasClass('registrations create') || $('body').hasClass('sessions new') || $('#sign_up_form')
    appid = $("meta[property='fb:app_id']").attr("content")
    window.fbAsyncInit = ->
      FB.init
        appId: appid
        xfbml: true
        version: 'v2.8'
      FB.getLoginStatus (response) ->
        if response.status == 'connected'
          access_token = response.authResponse.accessToken
          user_id = response.authResponse.userID
          
          $.ajax
            type: 'GET'
            url: 'https://graph.facebook.com/' + user_id + '?fields=first_name,picture&access_token=' + access_token
            dataType: 'jsonp'
            success: (json) ->
              first_name = json.first_name
              image_url = json.picture.data.url
              $(".facebook_button").each ->
                $(this).append("Login as " + first_name)
                $(this).append("<img src=" + image_url + ">")
              $(".textInclude-separator").removeClass('hide')
              $(".sns-buttons").removeClass('hide')
              return
        else if response.status == 'not_authorized'
          $(".facebook_button").each ->
            $(this).append("Sign up with Facebook account")
          $(".textInclude-separator").removeClass('hide')
          $(".sns-buttons").removeClass('hide')
        return
    
    ((d, s, id) ->
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      if d.getElementById(id)
        return
      js = d.createElement(s)
      js.id = id
      js.src = '//connect.facebook.net/ja_JP/sdk.js'
      fjs.parentNode.insertBefore js, fjs
      return
    ) document, 'script', 'facebook-jssdk'

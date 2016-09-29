$ ->
  #Favorite ON/OFF
  if $('body').hasClass('favorite_listings index') || $('body').hasClass('favorite_users index')
    return
  else
    setBtn = ->
      #balloon for favorites
      $('a.favorite-btn').each (index) ->
        if $(window).width() >= 768
          $(this).find('.fav-balloon').balloon(
            contents: 'add to your favorites',
            css:
              border: 'none',
              padding: '8px',
              fontSize: '13px',
              fontWeight: 'bold',
              lineHeight: '1.55',
              backgroundColor: 'rgba(0, 0, 0, .75)',
              borderRadius: '2px'
              color: 'white'
              boxShadow: 'none'
          )
        else
          $(this).on 'click', ->
            if !$(this).find('.fav-balloon').hasClass('hide')
              $(this).find('.fav-balloon').showBalloon(
                contents: 'add to your favorites',
                hideDuration: 1000,
                css:
                  border: 'none',
                  padding: '8px',
                  fontSize: '13px',
                  fontWeight: 'bold',
                  lineHeight: '1.55',
                  backgroundColor: 'rgba(0, 0, 0, .75)',
                  borderRadius: '2px'
                  color: 'white'
                  boxShadow: 'none'
              )
        
        $(this).find('i.outline').hover (->
          $(this).prev().addClass 'unfavorite-o'
          ), ->
          $(this).prev().removeClass 'unfavorite-o'
      
      if $('body').hasClass('listings show')
          $('.favorited-count').removeClass('hide')
      return
    
    # delete favorite
    $(document).on 'click', '.favorite-btn.del', ->
      favorite_id = $(this).attr('favorite_id')
      parent = $(this).parent("#favorite")
      $.ajax(
        type: 'DELETE'
        url: '/favorites/' + favorite_id
      ).done (data) ->
        parent.html(data)
        setBtn()
      return false
    
    # create favorite
    $(document).on 'click', '.favorite-btn.post', ->
      $(this).find('.fav-balloon').showBalloon().hideBalloon()
      target_id = $(this).attr('target_id')
      type = $(this).attr('type')
      user_id = $(this).attr('user_id')
      parent = $(this).parent("#favorite")
      $.ajax(
        type: 'POST'
        url: '/favorites'
        data: {
          target_id: target_id
          type: type
          user_id: user_id
        }
      ).done (data) ->
        parent.html(data)
        setBtn()
      return false
    
    setBtn()
#favorite.coffee
$ ->

  # favorite_listings
  # favorite_users
  if $('body').hasClass('favorite_listings index')
    $('a.favorite-btn').each (index) ->
      $(this).on 'click' , ->
        ret = confirm('お気に入りを解除します。よろしいですか？')
        if ret
          return
        else
          return false
  else if $('body').hasClass('favorite_users index')
    $('a.favorite-btn').each (index) ->
      $(this).on 'click' , ->
        ret = confirm('お気に入りを解除します。よろしいですか？')
  else
    $('.favorite-btn').each (index) ->
      $(this).on 'ajax:complete',  (event, ajax, status) ->
        if status == 'success'
          if ajax.responseJSON.post == 'create'
            $(this).find('i.favorited').removeClass 'hide'
            $(this).find('i.unfavorite').addClass 'hide'
            $(this).find('i.outline').addClass 'hide'
          else if ajax.responseJSON.post == 'delete'
            $(this).find('i.favorited').addClass 'hide'
            $(this).find('i.unfavorite').removeClass 'hide'
            $(this).find('i.outline').removeClass 'hide'

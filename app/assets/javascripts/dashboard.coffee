$ ->
  if $('body').hasClass('dashboard index')
    $(document).on 'click', '.favorite_hitory', ->
      $.ajax(
        type: 'GET'
        url: '/dashboard/favorite_histories'
        data: {
          user_id: $(this).attr('user_id')
          listing_id: $(this).attr('listing_id')
        }
      ).done (data) ->
        $('.subnav').before('<div id=modal_area></div>')
        $('#modal_area').html(data)
        $('#favorite_histories').modal()
      return false
  
    $(document).on 'hidden.bs.modal', '#favorite_histories', ->
      $('#modal_area').remove()
      return
      
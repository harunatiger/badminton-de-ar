# dashboard.coffee

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

    $(document).on 'change', '.chart_submit', ->
      if $(this).attr('id') == 'change_tour'
        $('#chart_data_day').before("<input type='hidden' name='change_tour' value=true />")
      $('#chart_from').submit()
      return

    $(document).on 'click', '#prev_month', ->
      $('#chart_data_day').before("<input type='hidden' name='prev_month' value=true />")
      $('#chart_from').submit()
      return false

    $(document).on 'click', '#next_month', ->
      $('#chart_data_day').before("<input type='hidden' name='next_month' value=true />")
      $('#chart_from').submit()
      return false

    $(document).on 'ajax:before', (event) ->
      $('#hidden-form-id').val(event.target.id)
      $('#listing-image-loading').modal()

    # update chart when window resized
    ###
    $(window).resize ->
      drawChart()
      return
    ###

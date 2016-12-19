# dashboard.coffee

#add reservation dot to date
SetReservationDot = ->
  setTimeout (->
    reservation_date_list = $("#reservation_date_list").attr('list').split(',')
    if reservation_date_list.length > 0
      $(".reservation-dot").each ->
        $(this).remove()

      $.each reservation_date_list, (index, elm) ->
        $("g g g text:contains(" + elm + ")").each ->
          if $(this).text() == elm.toString()
            id = "reservation-dot-" + elm
            html = "<div id='" + id + "' class='reservation-dot'><i class='fa fa-circle'></i></div>"
            top = $(this).offset().top + 10
            left = $(this).offset().left
            if elm >= 10
              left = left + 5

            $("#chart").after(html)
            $("#" + id).offset({ top: top, left: left })
            return false
  ), 500

$ ->
  if $('body').hasClass('dashboard index')

    $(document).on 'shown.bs.tab', '.tab-chart', (e) ->
      draw_chart()
      SetReservationDot()
      e.preventDefault()

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
      return

    $(document).ajaxSuccess (e) ->
      SetReservationDot()
      return

    # update chart when window resized
    $(window).resize ->
      draw_chart()
      SetReservationDot()
      return

    SetReservationDot()

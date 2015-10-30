#reservation, dashboard
$ ->

  $("[id^=reservation-item-show-recipe-]").on 'click', (e) ->
    alert 'ただいま準備中です。少々お待ちください。'
    e.preventDefault()

  $("[id^=reservation-item-as-guest-launch-message-]").on 'click', ->
    data_num = $(this).attr('data-num')
    $("#message-to-host-from-reservation-manager-" + data_num).modal()

  $("[id^=reservation-item-as-host-launch-message-]").on 'click', ->
    data_num = $(this).attr('data-num')
    $("#message-to-guest-from-reservation-manager-" + data_num).modal()

  # bootstrap datepicker
  disabled_dates = gon.ngdates
  $('.datepicker').datepicker
    autoclose: true,
    startDate: '+1d',
    language: 'ja',
    orientation: 'top auto',
    default: 'yyyy.mm.dd',
    format: 'yyyy/mm/dd',
    beforeShowDay: (date) ->
      formattedDate = $.fn.datepicker.DPGlobal.formatDate(date, 'yyyy.mm.dd', 'ja')
      if $.inArray(formattedDate.toString(), disabled_dates) != -1
        return { enabled: false }
      return


  # set reservation by listing_id for message thread
  logVal = ''
  $(document).on 'focus', '#reservation_listing_id', ->
    logVal = $('#reservation_listing_id').val()

  $(document).on 'change', '#reservation_listing_id', ->
    tour = $('#reservation_listing_id option:selected').text() + 'の情報に書き換えます。よろしいですか？これまで編集したガイド内容が上書きされます。ご注意ください。'
    ret = confirm(tour) if $(this).val() != ''
    if ret
      $.ajax(
        type: 'GET'
        url: '/reservations/set_reservation_by_listing'
        data: {
          listing_id: $(this).val(),
          reservation_id: $('#reservation_id').val()
        }
      ).done (data) ->
        $('#reservation_detail_form').html(data)
        disabled_dates = gon.ngdates
        # i'm stupid, hehe
        strfChange = $('.checkout').val()
        strfChange = strfChange.replace(/-/g, '/')
        $('.checkout').val(strfChange)
        $('.datepicker').datepicker
          autoclose: true,
          startDate: '+1d',
          language: 'ja',
          orientation: 'top auto',
          default: 'yyyy.mm.dd',
          format: 'yyyy/mm/dd',
          beforeShowDay: (date) ->
            formattedDate = $.fn.datepicker.DPGlobal.formatDate(date, 'yyyy.mm.dd', 'ja')
            if $.inArray(formattedDate.toString(), disabled_dates) != -1
              return { enabled: false }
    else
      $('#reservation_listing_id').val(logVal)
      return

  # set reservation default for message thread
  $(document).on 'click', '#cancel_detail', ->
    $.ajax(
        type: 'GET'
        url: '/reservations/set_reservation_default'
        data: {
          reservation_id: $('#reservation_id').val()
        }
      ).done (data) ->
        $('#reservation_detail_form').html(data)
        disabled_dates = gon.ngdates
        # i'm stupid, hehe
        strfChange = $('.checkout').val()
        strfChange = strfChange.replace(/-/g, '/')
        $('.checkout').val(strfChange)        
        $('.datepicker').datepicker
          autoclose: true,
          startDate: '+1d',
          language: 'ja',
          orientation: 'top auto',
          default: 'yyyy.mm.dd',
          format: 'yyyy/mm/dd',
          beforeShowDay: (date) ->
            formattedDate = $.fn.datepicker.DPGlobal.formatDate(date, 'yyyy.mm.dd', 'ja')
            if $.inArray(formattedDate.toString(), disabled_dates) != -1
              return { enabled: false }
            return

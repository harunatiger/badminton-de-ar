#reservation, dashboard
$ ->
  # loader preset
  $.fn.spin.presets.flower =
    lines: 7
    length: 0
    width: 4
    radius: 6

  # cencel tour btn
  $('#cancel_tour_btn').on 'click', ->
    targetForm = $(this).closest('form')
    spinner = $('.spinner', targetForm)
    spinner.spin('flower', 'white')
    $('.btn-frame > .btn', targetForm).addClass('text-disappear')

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
  disabled_weeks = gon.ngweeks
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
      if $.inArray(date.getDay(), disabled_weeks) != -1
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
      set_ngday_reservation_by_listing($(this).val(), $('#reservation_id').val())
      $.ajax(
        type: 'GET'
        url: '/reservations/set_reservation_by_listing'
        data: {
          listing_id: $(this).val(),
          reservation_id: $('#reservation_id').val()
        }
      ).done (data) ->
        $('#reservation_detail_form').html(data)
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
            if $.inArray(date.getDay(), disabled_weeks) != -1
              return { enabled: false }
    else
      $('#reservation_listing_id').val(logVal)
      return

  changed_flg = 0
  $('.message_form').on 'change', ->
    changed_flg = 1

  # set reservation default for message thread
  $(document).on 'click', '#cancel_detail', ->
    if changed_flg == 0
      $('#reservation_block-form').fadeOut()
      $('#reservation_block-info').fadeIn()
      $('html, body').animate(scrollTop: 0)
    else
      set_ngday_reservation_default($('#reservation_id').val())
      $.ajax(
          type: 'GET'
          url: '/reservations/set_reservation_default'
          data: {
            reservation_id: $('#reservation_id').val()
          }
        ).done (data) ->
          $('#reservation_detail_form').html(data)
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
              if $.inArray(date.getDay(), disabled_weeks) != -1
                return { enabled: false }
              return

  set_ngday_reservation_by_listing = (listing_id, reservation_id) ->
    $.ajax(
        type: 'GET'
        url: '/reservations/set_ngday_reservation_by_listing'
        data: {
          listing_id: listing_id,
          reservation_id: reservation_id
        }
      ).done (data) ->
        disabled_dates = data.ngdates
        disabled_weeks = data.ngweeks

  set_ngday_reservation_default = (reservation_id) ->
    $.ajax(
        type: 'GET'
        url: '/reservations/set_ngday_reservation_default'
        data: {
          reservation_id: reservation_id
        }
      ).done (data) ->
        disabled_dates = data.ngdates
        disabled_weeks = data.ngweeks

#reservation, dashboard
$ ->
  # loader preset
  $.fn.spin.presets.flower =
    lines: 7
    length: 0
    width: 4
    radius: 6

  # cencel tour btn
  $('.cancel_tour_btn').on 'click', ->
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
  $(document).on('click', '#reservation_detail_form #reservation_listing_id', ->
    logVal = $('#reservation_detail_form #reservation_listing_id').val()
    return
  ).on 'change', '#reservation_detail_form #reservation_listing_id', ->
    if $('#reservation_detail_form #reservation_listing_id').val() != ''
      tour = $('#reservation_detail_form #reservation_listing_id option:selected').text() + 'の情報に書き換えます。よろしいですか？これまで編集したガイド内容が上書きされます。ご注意ください。'
      ret = confirm(tour)
      if ret
        set_ngday_reservation_by_listing($('#reservation_detail_form #reservation_listing_id').val(), $('#reservation_form #reservation_id').val())
        $.ajax(
          type: 'GET'
          url: '/reservations/set_reservation_by_listing'
          data: {
            listing_id: $('#reservation_detail_form #reservation_listing_id').val(),
            reservation_id: $('#reservation_form #reservation_id').val()
          }
        ).done (data) ->
          $('#reservation_detail_form').html(data)
          # i'm stupid, hehe
          strfChange = $('.checkout').val()
          strfChange = strfChange.replace(/-/g, '/')
          $('#reservation_detail_form .checkout').val(strfChange)
          $('#reservation_detail_form .datepicker').datepicker
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

          $('#reservation_detail_form .option-check').each ->
            if $(this).is(':checked')
              $(this).parents('.collapse-trigger').next().collapse('show')

          $('#reservation_detail_form .option-check').on 'click', (e) ->
            if $(this).is(':checked')
              $(this).parents('.collapse-trigger').next().collapse('show')
            else
              $(this).parents('.collapse-trigger').next().collapse('hide')
      else
        $('#reservation_detail_form #reservation_listing_id').val(logVal)
        return
    else
      ret = confirm('編集した内容が全て消えますがツアーを変更してよろしいですか？')
      if ret
        $('#reservation_detail_form #reservation_time_required').val('0.0')
        $('#reservation_detail_form #reservation_schedule_hour').val('00')
        $('#reservation_detail_form #reservation_schedule_minute').val('00')
        $('#reservation_detail_form #reservation_price').val('0')
        $('#reservation_detail_form #reservation_price_for_support').val('0')
        $('#reservation_detail_form #reservation_price_for_both_guides').val('0')
        $('#reservation_detail_form #reservation_space_option').prop('checked', true)
        $('#reservation_detail_form #reservation_space_option').parents('.collapse-trigger').next().collapse('show')
        $('#reservation_detail_form #reservation_space_rental').val('0')
        $('#reservation_detail_form #reservation_car_option').prop('checked', true)
        $('#reservation_detail_form #reservation_car_option').parents('.collapse-trigger').next().collapse('show')
        $('#reservation_detail_form #reservation_car_rental').val('0')
        $('#reservation_detail_form #reservation_gas').val('0')
        $('#reservation_detail_form #reservation_highway').val('0')
        $('#reservation_detail_form #reservation_parking').val('0')
        $('#reservation_detail_form #reservation_guests_cost').val('0')
        $('#reservation_detail_form #reservation_included_guests_cost').val('')
        $('#reservation_detail_form #reservation_num_of_people').val('1')
        $('#reservation_detail_form #reservation_schedule_date').val('')
        $('#reservation_detail_form #reservation_schedule_end').val('')
        $('#reservation_detail_form #reservation_place').val('')
        $('#reservation_detail_form #reservation_place_memo').val('')
        $('#reservation_detail_form #reservation_description').val('')
        return
      else
        $('#reservation_detail_form #reservation_listing_id').val(logVal)
        return
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
      set_ngday_reservation_default($('#reservation_form #reservation_id').val())
      $.ajax(
          type: 'GET'
          url: '/reservations/set_reservation_default'
          data: {
            reservation_id: $('#reservation_form #reservation_id').val()
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
          $('.option-check').each ->
            if $(this).is(':checked')
              $(this).parents('.collapse-trigger').next().collapse('show')

          $('.option-check').on 'click', (e) ->
            if $(this).is(':checked')
              $(this).parents('.collapse-trigger').next().collapse('show')
            else
              $(this).parents('.collapse-trigger').next().collapse('hide')
          $('#reservation_block-form').fadeOut()
          $('#reservation_block-info').fadeIn()
          $('html, body').animate(scrollTop: 0)

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

  # open include_what
  $('a.include_what_trigger').on 'click', (e) ->
    $('#include_what').modal()
    $('#form_change_confirm').modal('hide')
    e.preventDefault()
    e.stopPropagation()
    return false

  # open include_what for dashboard
  $('.include_what_trigger_for_dashboard').on 'click', (e) ->
    index = $('.include_what_trigger_for_dashboard').index(this)
    $('.include_what' + index).modal()
    $('#form_change_confirm').modal('hide')
    e.preventDefault()
    e.stopPropagation()
    return false

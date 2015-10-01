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
    orientation: 'top auto'
    default: 'yyyy.mm.dd',
    beforeShowDay: (date) ->
      formattedDate = $.fn.datepicker.DPGlobal.formatDate(date, 'yyyy.mm.dd', 'ja')
      if $.inArray(formattedDate.toString(), disabled_dates) != -1
        return { enabled: false }
      return
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

  $('.cancel_tour_from_guide_btn').on 'click', ->
    targetForm = $(this).closest('form')
    if targetForm.find('#reservation_reason').val() == ''
      targetForm.find('.notice-blank').removeClass('hide')
      return false
    else
      spinner = $('.spinner', targetForm)
      spinner.spin('flower', 'white')
      $('.btn-frame > .btn', targetForm).addClass('text-disappear')
      return

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
  scheduleDate = $('#reservation_detail_form #reservation_schedule_date').val()
  $('#reservation_detail_form .datepicker').datepicker
    autoclose: true,
    startDate: '+1d',
    language: 'ja',
    orientation: 'top auto',
    default: 'yyyy.mm.dd',
    format: 'yyyy/mm/dd',
    beforeShowDay: (date) ->
      formattedDate = moment(date).format('YYYY.MM.DD')
      if $.inArray(formattedDate.toString(), disabled_dates) != -1
        return { enabled: false }
      if $.inArray(date.getDay(), disabled_weeks) != -1
        return { enabled: false }
      return
  if scheduleDate
    $('#reservation_detail_form #reservation_schedule_end').datepicker 'setStartDate', scheduleDate

  $(document).on 'change', '#reservation_detail_form #reservation_schedule_date', ->
    selected_date = $(this).val()
    $('#reservation_detail_form #reservation_schedule_end').val(selected_date)
    $('#reservation_detail_form #reservation_schedule_end').datepicker 'setStartDate', selected_date
    return
  
  if $('body').hasClass('message_threads show')
    # language of edit form
    changeLanguageText = ->
      language = ''
      $('.language_btn').each () ->
        if $(this).hasClass('btn-primary')
          language = $(this).text()
          return false
        
      if language == 'EN'
        $('#english_only_discription').text('')
        $('#select-tour').text('Select a tour')
        $('#time-required').text('Time required')
        $('#hours').text('hours')
        $('#your-guide-fee').text('Your guide fee')
        $('.yen').each () ->
          $(this).text('JPY')
        $('#support-guide-fee').text('Support guide fee')
        $('#car-option').text('Tour includes car rental fee (optional)')
        $('#car_rental').text('Car rental fee')
        $('#gas').text('Cost of gas')
        $('#highway').text('Cost of highway entry fees')
        $('#parking').text('Cost of parking')
        $('#bicycle-option').text('Tour includes bicycle rental fee (optional)')
        $('#bicycle_rental').text('Cost of renting bicycles')
        $('#other-option').text('Tour includes other costs (transportation fees, cost of food, cost of entry, etc.) (optional)')
        $('#other_cost').text('Other fees')
        $('#not-included-price').text('Approximate costs not included in tour price')
        $('#breakdown-of-above-costs').text('Breakdown of above costs')
        $('#number-of-people').text('Number of people')
        $('#people').text('people')
        $('#price-discription').text('Service fee will be calculated from the total of guide fees + additional costs (per group) + (additional costs (per guest) x number of people). This final total will be shown to guests.')
        $('#start-date').text('Start date')
        $('#end-date').text('End date')
        $('#meeting-at').text('Meeting at')
        $('#notes-about-meeting-place').text('Notes about meeting place')
        $('#meeting-time').text('Meeting time')
        $('#hour').text('')
        $('#minute').text('')
        $('#tour-notes').text('Tour notes')
        $('.about_payment_link').text('Important: About guest payment')
        $('#cancel_detail').val('Cancel')
        $('#cancel_detail').attr('data-disable-with', 'Cancel')
        $('#save').text('Save')
        
        $('#about_payment_title').text('About guest payment')
        $('#about_payment_body_1').text('There is a commission fee of ')
        $('#about_payment_body_2').text(' of the total tour price for using Huber. services.The commission fee will be automatically deducted from the tour payment when payment is complete.')
        $('#about_payment_body_3').text('Please see the terms of service for more information. ')
        $('#about_payment_close_button').text('Close')
      else if language == 'JA'
        $('#english_only_discription').text('＊入力は全て英語で行ってください。')
        $('#select-tour').text('ツアー選択')
        $('#time-required').text('所要時間')
        $('#hours').text('時間')
        $('#your-guide-fee').text('あなたの収入')
        $('.yen').each () ->
          $(this).text('円')
        $('#support-guide-fee').text('サポートメンバーの収入')
        $('#car-option').text('車両レンタル費が含まれるツアー(オプション費用)')
        $('#car_rental').text('車両レンタル代')
        $('#gas').text('ガソリン代')
        $('#highway').text('高速代')
        $('#parking').text('パーキング代')
        $('#bicycle-option').text('自転車レンタル費が含まれるツアー(オプション費用)')
        $('#bicycle_rental').text('自転車レンタル代')
        $('#other-option').text('その他(交通費、飲食代、体験代、場所代、人件費など)が含まれるツアー(オプション費用)')
        $('#other_cost').text('その他')
        $('#not-included-price').text('ゲストの費用(概算)')
        $('#breakdown-of-above-costs').text('上記費用の内訳')
        $('#number-of-people').text('人数')
        $('#people').text('人')
        $('#price-discription').text('ペアガイド料金＋諸費用（グループあたり）＋諸費用(ゲスト１名あたり)×人数にサービス料を足した値がゲストに表示されます。')
        $('#start-date').text('開始日')
        $('#end-date').text('終了日')
        $('#meeting-at').text('集合場所')
        $('#notes-about-meeting-place').text('集合場所のメモ')
        $('#meeting-time').text('集合時間')
        $('#hour').text('時')
        $('#minute').text('分')
        $('#tour-notes').text('ガイドの内容など')
        $('.about_payment_link').text('ゲストの支払いに関しての注意点')
        $('#cancel_detail').val('キャンセル')
        $('#cancel_detail').attr('data-disable-with', 'キャンセル')
        $('#save').text('保存')
        
        $('#about_payment_title').text('ゲストの支払いに関して')
        $('#about_payment_body_1').text('Huber.では、ツアー総額の')
        $('#about_payment_body_2').text('がシステム手数料として発生します。この費用はツアー代の金額支払時に自動的に差し引かれます。')
        $('#about_payment_body_3').text('詳しくはサービス規約をご確認ください。')
        $('#about_payment_close_button').text('閉じる')
      return false
    
    $(document).on 'click', '.language_btn', ->
      target = $(this)
      $.ajax(
        type: 'GET'
        url: '/message_threads/change_language'
        data: {
          language: $(this).text()
        }
      ).done (data) ->
        $('.language_btn').each () ->
          $(this).removeClass('btn-primary')
          $(this).addClass('btn-default')

        target.removeClass('btn-default')
        target.addClass('btn-primary')
        changeLanguageText()
      return false
    
    changeLanguageText()
    
    # set reservation by listing_id for message thread
    logVal = ''
    $(document).on('click', '#reservation_detail_form #reservation_listing_id', ->
      logVal = $('#reservation_detail_form #reservation_listing_id').val()
      return
    ).on 'change', '#reservation_detail_form #reservation_listing_id', ->
      if $('#reservation_detail_form #reservation_listing_id').val() != ''
        tour = 'Do you want to change the tour information for ' + $('#reservation_detail_form #reservation_listing_id option:selected').text() + '? This will overwrite the previous tour information.'
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
            scheduleDate = $('#reservation_detail_form #reservation_schedule_date').val()
            $('#reservation_detail_form .datepicker').datepicker
              autoclose: true,
              startDate: '+1d',
              language: 'ja',
              orientation: 'top auto',
              default: 'yyyy.mm.dd',
              format: 'yyyy/mm/dd',
              beforeShowDay: (date) ->
                formattedDate = moment(date).format('YYYY.MM.DD')
                if $.inArray(formattedDate.toString(), disabled_dates) != -1
                  return { enabled: false }
                if $.inArray(date.getDay(), disabled_weeks) != -1
                  return { enabled: false }

            if scheduleDate
              $('#reservation_detail_form #reservation_schedule_end').datepicker 'setStartDate', scheduleDate

            $('#reservation_detail_form .option-check').each ->
              if $(this).is(':checked')
                $(this).parents('.collapse-trigger').next().collapse('show')

            $('#reservation_detail_form .option-check').on 'click', (e) ->
              if $(this).is(':checked')
                $(this).parents('.collapse-trigger').next().collapse('show')
              else
                $(this).parents('.collapse-trigger').next().collapse('hide')
            changeLanguageText()
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
          #$('#reservation_detail_form #reservation_space_option').prop('checked', true)
          #$('#reservation_detail_form #reservation_space_option').parents('.collapse-trigger').next().collapse('show')
          #$('#reservation_detail_form #reservation_space_rental').val('0')
          $('#reservation_detail_form #reservation_car_option').prop('checked', true)
          $('#reservation_detail_form #reservation_car_option').parents('.collapse-trigger').next().collapse('show')
          $('#reservation_detail_form #reservation_car_rental').val('0')
          $('#reservation_detail_form #reservation_gas').val('0')
          $('#reservation_detail_form #reservation_highway').val('0')
          $('#reservation_detail_form #reservation_parking').val('0')
          $('#reservation_detail_form #reservation_bicycle_option').prop('checked', true)
          $('#reservation_detail_form #reservation_bicycle_option').parents('.collapse-trigger').next().collapse('show')
          $('#reservation_detail_form #reservation_bicycle_rental').val('0')
          $('#reservation_detail_form #reservation_other_option').prop('checked', true)
          $('#reservation_detail_form #reservation_other_option').parents('.collapse-trigger').next().collapse('show')
          $('#reservation_detail_form #reservation_other_cost').val('0')
          $('#reservation_detail_form #reservation_guests_cost').val('0')
          $('#reservation_detail_form #reservation_included_guests_cost').val('')
          $('#reservation_detail_form #reservation_num_of_people').val('1')
          $('#reservation_detail_form #reservation_schedule_date').val('')
          $('#reservation_detail_form #reservation_schedule_end').val('')
          $('#reservation_detail_form #reservation_place').val('')
          $('#reservation_detail_form #reservation_place_memo').val('')
          $('#reservation_detail_form #reservation_description').val('')
          changeLanguageText()
          return
        else
          $('#reservation_detail_form #reservation_listing_id').val(logVal)
          return
        return

    changed_flg = 0
    $('.message_form').on 'change', ->
      changed_flg = 1

    ngday_exist = false
    $('#offer_to_guest').on 'click', ->
      if exist_ngday_reservation($('#reservation_form #reservation_id').val())
        if ngday_exist == true
          confirm 'Do you want to offer this tour plan to your guest?'
        else
          alert 'NG日が設定されています。'
          return false

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
                formattedDate = moment(date).format('YYYY.MM.DD')
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
            changeLanguageText()

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

    exist_ngday_reservation = (reservation_id) ->
      $.ajax(
        type: 'GET'
        url: '/reservations/exist_ngday_reservation'
        data: {
          reservation_id: reservation_id
        }
        async: false
      ).done (data) ->
        ngday_exist = data.ret

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

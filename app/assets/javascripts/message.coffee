#message.coffee
$ ->

  # message_threads#show
  if $('body').hasClass('message_threads show')
    if $('#what_talk_about')
      $('#what_talk_about').modal()

    # option price collapse
    $('.option-check').each ->
      if $(this).is(':checked')
        $(this).parents('.collapse-trigger').next().collapse('show')

    $('.option-check').on 'click', (e) ->
      if $(this).is(':checked')
        $(this).parents('.collapse-trigger').next().collapse('show')
      else
        $(this).parents('.collapse-trigger').next().collapse('hide')

    isFormcheck = ->
      if $('#non_special_offer_form #reservation_listing_id').val() == ''
        return false
      if $('#non_special_offer_form #reservation_schedule_hour').val() == ''
        return false
      if $('#non_special_offer_form #reservation_time_required').val() == '0.0'
        return false
      #if $('#non_special_offer_form #reservation_space_option').prop('checked') == true
      #  if $('#non_special_offer_form #reservation_space_rental').val() == '0'
      #    return false
      if $('#non_special_offer_form #reservation_car_option').prop('checked') == true
        rental = $('#non_special_offer_form #reservation_car_rental').val()
        gas = $('#non_special_offer_form #reservation_gas').val()
        highway = $('#non_special_offer_form #reservation_highway').val()
        parking = $('#non_special_offer_form #reservation_parking').val()
        if parseInt(rental) + parseInt(gas) + parseInt(highway) + parseInt(parking) == 0
          return false
      if $('#non_special_offer_form #reservation_bicycle_option').prop('checked') == true
        if $('#non_special_offer_form #reservation_bicycle_rental').val() == '0'
          return false
      if $('#non_special_offer_form #reservation_other_option').prop('checked') == true
        if $('#non_special_offer_form #reservation_other_cost').val() == '0'
          return false
      #if $('#non_special_offer_form #reservation_guests_cost').val() != '0'
      #  if $('#non_special_offer_form #reservation_included_guests_cost').val() == ''
      #    return false
      if $('#non_special_offer_form #reservation_schedule_date').val() == ''
        return false
      if $('#non_special_offer_form #reservation_schedule_end').val() == ''
        return false
      if $('#non_special_offer_form #reservation_place').val() == ''
        return false
      #if $('#non_special_offer_form #reservation_place_memo').val() == ''
      #  return false
      if $('#non_special_offer_form #reservation_description').val() == ''
        return false
      return

    if $('.state-primary').length == 0
      if $('#offer_to_guest').length
        if isFormcheck() == false
          $('#offer_to_guest').addClass("disabled")
          $('#offer_comment').text('＊必須情報を登録して、オファーをしましょう。')
        else
          $('#offer_to_guest').removeClass("disabled")
          $('#offer_comment').text('＊登録された情報でオファーできます。')
    else
      $('#offer_comment').text('＊ツアー内容をオファー済みです。内容を変更するにはゲストにオファーのキャンセルを依頼してください。')


  # loader preset
  $.fn.spin.presets.flower =
    lines: 7
    length: 0
    width: 4
    radius: 6

  # reservation_block toggle
  $('#reservation_block-toggle').on 'click', ->
    $('#reservation_block-info').fadeOut()
    $('#reservation_block-form').fadeIn()
    if $('div.alert').length
      $('div.alert').remove()

  # cancel step
  #$('.cc_to_step2').on 'click', ->
  #  $('.step1').hide()
  #  $('.step2').show()
  #$('.cc_to_step3').on 'click', ->
  #  $('.step2').hide()
  #  $('.step3').show()

  # Launch Modal at Message Thread page
  $('.confirm_cancel_link').on 'click', ->
    index = $('.confirm_cancel_link').index(this)
    $('[id=confirm_cancel]').eq(index).modal(
      backdrop: 'static'
    )
    return false

  booking_index = 0
  $('.confirm_cancel_from_guide_link').on 'click', ->
    booking_index = $('.confirm_cancel_from_guide_link').index(this)
    $('[id=confirm_cancel_from_guide]').eq(booking_index).modal(
      backdrop: 'static'
    )
    return false

  $('.cc_to_step2').on 'click', ->
    element = $('[id=confirm_cancel_from_guide]').eq(booking_index)
    element.find('.step1').hide()
    element.find('.step2').show()
  $('.cc_to_step3').on 'click', ->
    element = $('[id=confirm_cancel_from_guide]').eq(booking_index)
    element.find('.step2').hide()
    element.find('.step3').show()
    element.find('#reservation_reason').val('')
    if !element.find('.notice-blank').hasClass('hide')
      element.find('.notice-blank').addClass('hide')

  $('a.about_cancel_from_guide_link').on 'click', ->
    $('#about_cancel_from_guide').modal()
    return false

  #booking_index = 0
  #$('.confirm_cancel_from_guide_link').each (index) ->
  #  $(this).on 'click' , ->
  #    booking_index = index
  #    $('#confirm_cancel_from_guide1').modal()
  #$('.confirm_cancel_from_guide2').on 'click', ->
  #  $('#confirm_cancel_from_guide1').modal('hide')
  #  $('#confirm_cancel_from_guide2').modal()
  #$('.confirm_cancel_from_guide3').on 'click', ->
  #  $('#confirm_cancel_from_guide2').modal('hide')
  #  $('[id=confirm_cancel_from_guide3]').eq(booking_index).modal(
  #    backdrop: 'static'
  #  )


  $('a.about_cancel_link').on 'click', ->
    if $(this).hasClass('from_modal')
      $('#about_cancel').addClass('from_modal')
    $('#about_cancel').modal()
    return false
  # remove backdrop class
  $('#about_cancel').on 'hidden.bs.modal', ->
    if $(this).hasClass('from_modal')
      $('#about_cancel').removeClass('from_modal')
    return
  $('a.about_payment_link').on 'click', ->
    $('#about_payment').modal()
    return false

  # Launch Modal at Listing detail page
  $('#message-host-link').on 'click', ->
    $('#message-to-host').modal()

  $('#message-host-link-bottom').on 'click', ->
    $('#message-to-host').modal()

  $('#message-host-link-subnav').on 'click', ->
    $('#message-to-host').modal()

  $('#message-host-link-fixed').on 'click', ->
    $('#message-to-host').modal()

  # Start Message Sending Process
  ## message from lisitng detail page
  $('#message-to-host-btn').on 'click', (e) ->
    form_target = $('#message-to-host-form')
    modal_target = $('#message-to-host')
    messageSendingProcesses(e, form_target, modal_target)

  ## message from dashboard guest reservation manager
  $("[id^=message-to-host-with-reservation-btn-]").on 'click', (e) ->
    data_num = $(this).attr('data-num')
    form_target = $('#message-to-host-with-reservation-form-' + data_num)
    modal_target = $('#message-to-host-from-reservation-manager-' + data_num)
    messageSendingProcesses(e, form_target, modal_target)

  ## message from dashboard host reservation manager
  $("[id^=message-to-guest-with-reservation-btn-]").on 'click', (e) ->
    data_num = $(this).attr('data-num')
    form_target = $('#message-to-guest-with-reservation-form-' + data_num)
    modal_target = $('#message-to-guest-from-reservation-manager-' + data_num)
    messageSendingProcesses(e, form_target, modal_target)

  ## common function
  ## # message sending process: adapter
  messageSendingProcesses = (e, form_target, modal_target) ->
    e.preventDefault()
    return unless validateMessageAjaxForm(form_target)
    sendMessageViaAjax(form_target, modal_target)
    return

  ## # message sending process: validation
  validateMessageAjaxForm = (form_target) ->
    form_target.validate
      errorPlacement: (error, element) ->
        error.insertBefore(element)
        return true
      rules:
        'message[content]':
          required: true
      messages: 'message[content]':
        required: 'メッセージを入力してください'

    if form_target.valid()
      return true
    else
      return false

  ## # message sending process: sending message as ajax
  sendMessageViaAjax = (form_target, modal_target) ->
    console.log form_target
    console.log form_target.serializeArray()
    console.log form_target.attr('action')
    console.log form_target.attr('method')
    thiser = form_target
    spinner = $('.spinner', thiser)
    spinner.spin('flower', 'white')
    $('.btn-frame > .btn', thiser).addClass('text-disappear')
    jqXHR = $.ajax({
      async: true
      url: form_target.attr('action')
      type: form_target.attr('method')
      data: form_target.serializeArray()
      dataType: 'json'
      cache: false
      })
    jqXHR.done (data, stat, xhr) ->
      console.log { done: stat, data: data, xhr: xhr }
      alert 'メッセージを送信しました。'
    jqXHR.fail (xhr, stat, err) ->
      console.log { fail: stat, error: err, xhr: xhr }
      console.log xhr.responseText
      alert 'メッセージを送信できませんでした。'
    jqXHR.always (res1, stat, res2) ->
      console.log { always: stat, res1: res1, res2: res2 }
      modal_target.modal('hide')
      $('.btn-frame > .btn', thiser).removeClass('text-disappear')
    return

  ## # modal view the attachment using ajax
  $(document).on 'click', 'a.preview-attached-trigger', ->
    $.ajax(
      type: 'GET'
      url: '/messages/show_preview'
      data: {
        'id': $(this).data('image')
      }
    ).done (data,status) ->
      if status == 'success'
        $('#preview-show').html(data)
        $('#preview-attached').modal()
        return false
      else
        return false
    return false

  if $('body').hasClass('message_threads index')
    if $(window).width() < 768
      # ellipsis message_thread username
      $setElm = $('.thread-name .user-name')
      cutFigure = '35'
      afterTxt = ' …'
      $setElm.each ->
        beforeTxt = $.trim($(this).text())
        textLength = beforeTxt.length
        textTrim = beforeTxt.substr(0, cutFigure)
        if cutFigure < textLength
          $(this).html(textTrim + afterTxt)
        return

  if $('body').hasClass('dashboard host_reservation_manager')
    $(document).on 'ajax:success',  (event) ->
      $target = $(event.target)
      count = $target.children('#count').val()
      element = $('ul.thread-list li.reservation-thread').eq(count)
      console.log element
      element.find('.thread-progress .state').removeClass('state-primary')
      element.find('.thread-progress .state').addClass('state-normal')
      element.find('.thread-progress .state').text('Cancelled')
      element.find('.confirm_cancel_from_guide_link').addClass('hide')
      element.find('.step1').hide()
      element.find('.step2').hide()
      element.find('.step3').hide()
      element.find('.step4').show()

  if $('body').hasClass('dashboard guest_reservation_manager')
    $(document).on 'ajax:success',  (event) ->
      $target = $(event.target)
      count = $target.children('#count').val()
      element = $('ul.thread-list li.reservation-thread').eq(count)
      console.log element
      element.find('.thread-progress .state').removeClass('state-primary')
      element.find('.thread-progress .state').addClass('state-normal')
      element.find('.thread-progress .state').text('Cancelled')
      element.find('.confirm_cancel_link').addClass('hide')
      element.find('.step1').hide()
      element.find('.step3').show()
      
  if $('body').hasClass('message_threads show')
    $('.profile_alert_link').on 'click', ->
      $('html,body').animate { scrollTop: 0 }, 'slow'
      $('#flash').flicker
        'reps': 7
        'pause': 200
        'delay': 800
        'color': 'rgb(249, 238, 145)'
      return false

#message
$ ->

  # loader preset
  $.fn.spin.presets.flower =
    lines: 7
    length: 0
    width: 4
    radius: 6

  # Launch Modal at Listing detail page
  $('#message-host-link').on 'click', ->
    $('#message-to-host').modal()

  $('#message-host-link-bottom').on 'click', ->
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
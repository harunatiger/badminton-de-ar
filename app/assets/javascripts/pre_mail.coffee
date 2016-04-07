$ ->
  $('#new_pre_mail').submit ->
    if $('#pre_mail_email').val() == '' or $('#pre_mail_last_name').val() == '' or $('#pre_mail_first_name').val() == '' or $('#pre_mail_prefecture_code').val() == '' or $('#pre_mail_municipality').val() == ''
      alert '未入力の項目があります。'
      return false
    else
      targetForm = $(this).closest('form')
      spinner = $('.spinner', targetForm)
      spinner.spin('flower', 'white')
      $('.btn-frame > .btn', targetForm).addClass('text-disappear')
      return
    
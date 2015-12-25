$ ->
  $('#new_pre_mail').submit ->
    if $('#pre_mail_email').val() == '' or $('#pre_mail_last_name').val() == '' or $('#pre_mail_first_name').val() == ''
      alert '未入力の項目があります。'
      return false
    
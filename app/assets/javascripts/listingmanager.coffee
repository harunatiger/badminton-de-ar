#ajax
$ ->

  $('#listing-manager-listing-image-submit').on 'click', ->
    postData = $(this).serializeArray()
    postData.append('listing_image[image]', $input[0].files[0]);
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      #data: new FormData($("#new_form")[0])
      processData: false
      contentType: false
      success: (data, textStatus, jqXHR) ->
        alert '画像を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '画像の登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'upload complete'

  $('#listing-manager-listing-submit').on 'click', ->
    postData = $(this).serializeArray()
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      success: (data, textStatus, jqXHR) ->
        alert 'リスティング情報を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'update complete'

  $('#listing-manager-confection-submit').on 'click', ->
    postData = $(this).serializeArray()
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      success: (data, textStatus, jqXHR) ->
        alert 'お菓子の情報を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'update complete'

  $('#listing-manager-tool-submit').on 'click', ->
    postData = $(this).serializeArray()
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      success: (data, textStatus, jqXHR) ->
        alert 'お道具の情報を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'update complete'

  $('#listing-manager-dress-code-submit').on 'click', ->
    postData = $(this).serializeArray()
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      success: (data, textStatus, jqXHR) ->
        alert '服装の情報を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'update complete'

  $('#listing-manager-open').on 'click', ->
    postData = $(this).serializeArray()
    formURL = $(this).attr('action')
    console.log postData
    console.log formURL
    $.ajax
      url: formURL
      type: $(this).attr('method')
      data: postData
      success: (data, textStatus, jqXHR) ->
        alert '服装の情報を登録しました。'
        console.log 'success'
      error: (jqXHR, textStatus, errorThrown) ->
        alert '登録に失敗しました。'
        console.log 'failure'
      complete:
        console.log 'update complete'

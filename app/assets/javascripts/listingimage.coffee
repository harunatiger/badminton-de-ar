$ ->
  if $('body').hasClass('listing_images manage')
    $('#listing_cover_video').filestyle input: false, buttonText: '動画を追加', size: "lg", iconName: "fa fa-cloud-upload", badge: false
    $('#listing_image_new').filestyle input: false, buttonText: '画像を追加', size: "lg", iconName: "fa fa-cloud-upload", badge: false
    
    $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
    $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')

    image_from = ''
    $(document).on 'dragstart', '.image-draggable', ->
      image_from = $('.image-draggable').index(this)

    $(document).on 'drop', '.image-droppable', ->
      image_to = $('.image-droppable').index(this)
      listing_id = $('#listing_id').val()
      $.ajax(
        type: 'PUT'
        url: '/listings/' + listing_id + '/listing_images/change_order'
        data: {
          listing_id: listing_id ,
          image_from: image_from + 1,
          image_to: image_to + 1
        }
      ).done (data) ->
        $('#images_list').html(data)
        $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
        $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')

    $(document).on 'ajax:before', (event) ->
      $('#hidden-form-id').val(event.target.id)
      $('#listing-image-loading').modal()
    $(document).on 'ajax:success',  (event) ->
      $('#listing-image-loading').modal('hide')
    $(document).on 'ajax:error',  (event) ->
      $('#listing-image-loading').modal('hide')

  #upload video
  $(document).on 'change', '#listing_cover_video', ->
    $('#upload_video').submit()
    return

  #upload image (new)
  $(document).on 'change', '#listing_image_new', ->
    $('#upload_image').submit()
    return
  
  image_index = 0
  $(document).on 'click', '.set_listing_image_link', ->
    image_index = $('.set_listing_image_link').index(this)
    $('[id=set_listing_image]').eq(image_index).modal(
      backdrop: 'static'
    )
    return false

  category_index = 0
  $(document).on 'click', '.set_category_link', ->
    category_index = $('.set_category_link').index(this)
    listing_image_id = $('.set_category_link').eq(category_index).attr("listing_image_id")
    listing_id = $('#listing_id').val()
    category = $('[id=category]').eq(category_index).val()
    $.ajax(
      type: 'POST'
      url: '/listings/' + listing_id + '/listing_images/' + listing_image_id + '/set_category'
      data: {
        category: category
      }
    ).done (result) ->
      if result == 'deleted'
        $('.set_category_link').eq(category_index).removeClass 'listing_image_selected'
      else if result == 'added'
        $('.set_category_link').eq(category_index).addClass 'listing_image_selected'
      else
        console.log 'faile to update'
    return false
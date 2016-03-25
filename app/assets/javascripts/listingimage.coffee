$ ->
  if $('body').hasClass('listing_images manage')
    videoHelp = $('.listing_help_block #tour-video-help')
    imageHelp = $('.listing_help_block #tour-image-help')
    videoHelp.css('top', '50px')
    imageHelp.css('top', '300px')
    
    #change file button style
    $('#listing_cover_video').filestyle input: false, buttonText: '動画を追加', size: "lg", iconName: "fa fa-cloud-upload", badge: false
    $('#listing_image_new').filestyle input: false, buttonText: '画像を追加', size: "lg", iconName: "fa fa-cloud-upload", badge: false
    $('#listing_image_new_footer').filestyle input: false, buttonText: '画像を追加', size: "lg", iconName: "fa fa-cloud-upload", badge: false
    
    # drag and drop
    $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
    $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'intersect')

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
        $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'intersect')

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

    $(document).on 'click', '.set_listing_image_link', ->
      listing_image_id = $(this).attr("listing_image_id")
      $('[id=set_listing_image' + listing_image_id + ']').modal(
        backdrop: 'static'
      )
      return false

    category_index = 0
    $(document).on 'click', '.set_category_link', (e)->
      e.preventDefault()
      category_index = $('.set_category_link').index(this)
      listing_image_id = $('.set_category_link').eq(category_index).attr("listing_image_id")
      listing_id = $('#listing_id').val()
      category = $('[id=category]').eq(category_index).val()
      $.ajax
        type: 'POST'
        url: '/listings/' + listing_id + '/listing_images/' + listing_image_id + '/set_category'
        data: {category: category}
        success: (data) ->
          old_index = (Number data) + (Number category_index)
          $('.set_category_link').eq(old_index).removeClass 'listing_image_selected'
          $('.set_category_link').eq(category_index).addClass 'listing_image_selected'
          return false
        error: ->
          return false
      return

    $(document).on 'click', '.add_image', ->
      $('#listing_image_new').trigger 'click'
      return false
module VideoJsHelper
  def video_player *args
    options = { width: 640, height: 360, class: 'video-js vjs-default-skin', :'data-setup' => '{}' }.merge args.extract_options!
    src = options.delete(:src) || {}

    content_tag :video, options do
      raw src.map { |type, url| raw tag(:source, src: url, type: "video/#{type}") }.join('')
    end
  end
end

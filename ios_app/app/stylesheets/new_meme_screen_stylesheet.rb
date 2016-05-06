class NewMemeScreenStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed,
  # example: include FooStylesheet

  attr_accessor :template

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def container(st)
    width_to_height_ratio = template.width.to_f / template.height.to_f
    height = device.screen_width / template.ratio
    st.frame = { l: 0, t: 50, w: :full, h: device.screen_width / width_to_height_ratio }
  end

  def scroll_view(st)
    st.frame = :full
    # st.scroll_enabled = true
    # st.shows_vertical_scroll_indicator = true
    st.content_size = CGSizeMake(screen_width, screen_height * 1.5)
  end

  def meme_image(st)
    st.frame = :full
    st.remote_image = template.image_url
    st.content_mode = :scale_aspect_fit
  end

  def top_text(st)
    st.frame = { t: 0, w: screen_width - 20, h: 50, centered: :horizontal }
    text_field(st)
  end

  def bottom_text(st)
    st.frame = { fb: 0, w: screen_width - 20, h: 50, centered: :horizontal }
    text_field(st)
  end

  def text_field(st)
    # st.font = font.meme_font
    # st.color = color.white
    # st.background_color = color.text_field_background
    st.default_text_attributes = {
      NSFontAttributeName => font.meme_font,
      NSForegroundColorAttributeName => color.white,
      NSStrokeWidthAttributeName => -4,
      NSStrokeColorAttributeName => color.black,
    }
    st.attributed_placeholder = NSAttributedString.alloc.initWithString "TEXT GOES HERE", attributes: st.default_text_attributes
    # st.attributed_placeholder = NSAttributedString.alloc.initWithString "TEXT GOES HERE", attributes: {
    #   NSForegroundColorAttributeName => color.battleship_gray
    # }
    st.text_alignment = :center
    st.autocapitalization_type = UITextAutocapitalizationTypeAllCharacters
    st.autocorrection_type = UITextAutocorrectionTypeNo
    st.adjusts_font_size_to_fit_width = true
    # st.return_key_type = :done
  end
end

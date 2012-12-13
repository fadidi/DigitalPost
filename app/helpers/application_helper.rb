module ApplicationHelper

  # @author John Brown
  # Returns an html5 <time> tag with a nicely formatted human date.
  #
  # @param [Object] time
  #
  # @return [String] HTML5 <time> tag with UTC date in datetime parameter
  #
  def pretty_time(time, options = {})
    content_tag(:time, time.strftime('%d %b %Y'), options.merge(:datetime => time.getutc.iso8601)) if time
  end   

  # @author John Brown
  # Returns an html5 <time> tag ready for jquery.timeago
  #
  # @param [Object] time
  #
  # @return [String] HTML5 <time> tag with UTC date in datetime parameter
  #
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(:datetime => time.getutc.iso8601)) if time
  end   

  # @author John Brown
  # Converts Markdown text to HTML.
  #
  # @param [String] Markdown
  #
  # @return [String] HTML
  #
  def markdown(text)
    Markdown.render(text).html_safe
  end

  # @author John Brown
  # Converts boolean to icons.
  #
  # @param [Boolean] state
  #
  # @return [String] HTML icon
  #
  def boolean_icon_for(state)
    raw('<span class="icon-ok"></span>') if state
  end

  # @author John Brown
  # Converts model name to icon
  #
  # @param [String] model
  #
  # @return [String] HTML span/icon
  #
  def icon_for(resource, text = nil, white = false)
    icons = {
      'case_study' => 'road',
      'document' => 'file',
      'home' => 'home',
      'language' => 'bullhorn',
      'library' => 'book',
      'link' => 'hand-right',
      'moment' => 'time',
      'page' => 'list-alt',
      'photo' => 'picture',
      'region' => 'globe',
      'sector' => 'filter',
      'staff' => 'user',
      'stage' => 'plane',
      'tag' => 'tag',
      'tags' => 'tags',
      'timeline' => 'time',
      'unit' => 'briefcase',
      'user' => 'user',
      'volunteer' => 'user',
      'work_zone' => 'flag'
    }
    text = text.nil? ? '' : "&nbsp;#{text}"
    icons[resource] ||= 'certificate'
    raw("<span class='icon-#{icons[resource]} #{'icon-white' if white}'></span>#{text}")
  end

  # @author John Brown
  # Converts action verb and options text to icon.
  #
  # @param [String] verb
  # @param [String] text
  #
  # @return [String] HTML span/icon
  #
  def action_icon(verb, text = nil, light = false)
    icons = {
      :create => 'plus',
      :edit => 'pencil',
      :destroy => 'minus',
      :upload => 'upload',
      :add => 'plus'
    }
    icons[verb] ||= 'certificate'
    content = text.nil? ? t("action.#{verb.to_s}") : text
    raw("<span class='icon-#{icons[verb]} #{'icon-white' if light}'></span> #{content.titleize}")
  end

  # @author John Brown
  # Accepts resource and creates destroy button
  #
  # @param [Constant] resource
  #
  # @return [String] destroy button link
  #
  def destroy_button(resource)
    link_to raw(action_icon(:destroy, t('phrase.destroy_resource', :resource => resource.class.model_name.human))), resource, :confirm => t('phrase.confirm_destroy'), :class => 'btn btn-danger', :method => :delete
  end

end

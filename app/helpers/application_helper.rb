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
  def icon_for(resource, text = nil)
    icons = {
      'language' => 'bullhorn',
      'page' => 'list-alt',
      'staff' => 'user',
      'user' => 'user',
      'volunteer' => 'user'
    }
    text = text.nil? ? '' : "&nbsp;#{text}"
    icons[resource] ||= 'certificate'
    raw("<span class='icon-#{icons[resource]}'></span>#{text}")
  end

  # @author John Brown
  # Converts action verb and options text to icon.
  #
  # @param [String] verb
  # @param [String] text
  #
  # @return [String] HTML span/icon
  #
  def action_icon(verb, text)
    icons = {
      :create => 'plus',
      :edit => 'pencil',
      :destroy => 'minus',
    }
    icons[verb] ||= 'certificate'
    raw("<span class='icon-#{icons[verb]}'></span> #{text}")
  end

end

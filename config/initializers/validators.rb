class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not a valid email address")
    end
  end
end

class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value, options = { :allow_future => true })
    if value.blank?
      record.errors[attribute] << (options[:message] || 'must be present and in the proper format (yyyy-mm-dd)')
    elsif value < '1961-01-01'.to_date
      record.errors[attribute] << (options[:message] || 'must be later than Jan 1, 1961')
    elsif !options[:allow_future] && value > Date.today
      record.errors[attribute] << (options[:message] || "must not be in the future: that just doesn't make sense!")
    end
  end
end

class AlphanumericValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^([a-z])+$/i
      record.errors[attribute] << (options[:message] || "is not alphanumeric")
    end
  end
end

class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[0-9\.\- +]+$/
      record.errors[attribute] << (options[:message] || "is not a reasonable phone number")
    end
  end
end

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^https?:\/\/[a-z]+.[a-zA-Z]+[-\/0-9a-z_%?=.&]*$/i
      record.errors[attribute] << (options[:message] || "is not a valid URL (as far as we can tell)")
    end
  end
end

class Iso2Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Carmen.country_name(value).nil?
      record.errors[attribute] << (options[:message] || "is not a valid ISO 2-letter country code")
    end
  end
end

# Based on: https://gist.github.com/795665
class FileSizeValidator < ActiveModel::EachValidator
  MESSAGES  = { :is => :wrong_size, :minimum => :size_too_small, :maximum => :size_too_big }.freeze
  CHECKS    = { :is => :==, :minimum => :>=, :maximum => :<= }.freeze

  DEFAULT_TOKENIZER = lambda { |value| value.split(//) }
  RESERVED_OPTIONS  = [:minimum, :maximum, :within, :is, :tokenizer, :too_short, :too_long]

  def initialize(options)
    if range = (options.delete(:in) || options.delete(:within))
      raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
      options[:minimum], options[:maximum] = range.begin, range.end
      options[:maximum] -= 1 if range.exclude_end?
    end

    super
  end

  def check_validity!
    keys = CHECKS.keys & options.keys

    if keys.empty?
      raise ArgumentError, 'Range unspecified. Specify the :within, :maximum, :minimum, or :is option.'
    end

    keys.each do |key|
      value = options[key]

      unless value.is_a?(Integer) && value >= 0
        raise ArgumentError, ":#{key} must be a nonnegative Integer"
      end
    end
  end

  def validate_each(record, attribute, value)
    raise(ArgumentError, "A CarrierWave::Uploader::Base object was expected") unless value.kind_of? CarrierWave::Uploader::Base
    
    value = (options[:tokenizer] || DEFAULT_TOKENIZER).call(value) if value.kind_of?(String)

    CHECKS.each do |key, validity_check|
      next unless check_value = options[key]

      value ||= [] if key == :maximum

      value_size = value.size
      next if value_size.send(validity_check, check_value)

      errors_options = options.except(*RESERVED_OPTIONS)
      errors_options[:file_size] = help.number_to_human_size check_value

      default_message = options[MESSAGES[key]]
      errors_options[:message] ||= default_message if default_message

      record.errors.add(attribute, MESSAGES[key], errors_options)
    end
  end
  
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end
end

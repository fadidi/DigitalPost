class Reference < ActiveRecord::Base
  attr_accessible :link_source_id, :link_source_type, :link_target_id, :link_target_type, :link_text

  belongs_to :link_target, :polymorphic => true
  belongs_to :link_source, :polymorphic => true

  validates :link_text, :presence => true, :length => { :maximum => 255 }
  validates :link_source_id, :link_source_type, :presence => true

  default_scope :order => 'link_text ASC'
  scope :to_pages, where(:link_target_type => 'Page')

  def self.process_string(original, source)
    source.references.clear
    original.gsub(/(\[([a-z_]*)\[((https*:\/\/)*[^\[]+)\]\])/) do |match|
      if $4.blank?
        if $2 == 'user'
          target = 'User'
          results = User.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        elsif $2 == 'unit'
          target = 'Unit'
          results = Unit.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        elsif $2 == 'language'
          target = 'Language'
          results = Language.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        elsif $2 == 'region'
          target = 'Region'
          results = Region.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        elsif $2 == 'sector'
          target = 'Sector'
          results = Sector.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        elsif $2 == 'work_zone'
          target = 'WorkZone'
          results = WorkZone.where("UPPER(name) LIKE UPPER(?)", "%#{$3}%")
        else
          target = 'Page'
          results = Page.where("UPPER(title) LIKE UPPER(?)", "%#{$3}%")
        end
          
        source.references.create!(
          :link_text => $3,
          :link_target_type => target,
          :link_target_id => (results.any? ? results.first.id : nil)
        )

        # if there are no results, set the missing link
        if results.count < 1
          "<a class=\"missing\" href=\"/#{target.underscore.pluralize}\">#{$3}<span class=\"icon-remove-circle\"></span></a>"
        # if there are more than 1 result, link to disambiguation
        elsif results.count > 1
          "<a class=\"disambiguation\" href=\"/#{target.underscore.pluralize}\">#{$3}<span class=\"icon-random\"></span></a>"
        # if there is only one result, link there
        else
          "<a href=\"/#{target.underscore.pluralize}/#{results.first.to_param}\">#{$3}</a>"
        end
      else
        source.references.create!(
          :link_text => $3
        )
        "<a href=\"#{$3}\">#{$3}</a>"
      end
    end
  end

end

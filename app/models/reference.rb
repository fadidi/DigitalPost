class Reference < ActiveRecord::Base
  attr_accessible :link_source_id, :link_source_type, :link_target_id, :link_target_type, :link_text, :target_count

  belongs_to :link_target, :polymorphic => true
  belongs_to :link_source, :polymorphic => true

  validates :link_text, :presence => true, :length => { :maximum => 255 }
  validates :link_source_id, :link_source_type, :presence => true
  validates :target_count, :presence => true, :numericality => { :is_integer => true }

  default_scope :order => 'link_text ASC'
  scope :to_pages, where(:link_target_type => 'Page')
  scope :valid, where('target_count = 1')
  scope :missing, where('target_count < 1')
  scope :ambiguous, where('target_count > 1')

  def is_ambiguous?
    target_count > 1 && !new_record?
  end

  def is_missing?
    target_count < 1 && !new_record?
  end

  def self.process_string(original, source)
    source.references.clear
    original.gsub(/(\[([a-z_]*)(:([a-z]+))*\[((https*:\/\/)*[^\[]+)\]([a-z0-9:;]*)\])/) do |match|
      # old set
      # $1 = whole set
      # $2 = resource
      # $3 = link text
      # $4 = http/s

      # new set
      # $1 = whole set
      # $2 = resource
      # $3 = :embed
      # $4 = embed
      # $5 = link text/url
      # $6 = http/s

      # if there is no http/s
      if $6.blank?
        # if there is no resource set
        if $2.blank?
          search = Tire.search ELASTICSEARCH_INDEX do |search|
            search.query do |query|
              query.string $5
            end
          end
          if search.results.count > 1
            ref = source.references.create!(
              :link_text => $5,
              :target_count => search.results.count
            )
            "<a class=\"disambiguation\" href=\"/references/#{ref.id}\">#{$5}<span class=\"icon-random\"></span></a>"
          elsif search.results.count == 1
            source.references.create!(
              :link_text => $5,
              :target_count => 1,
              :link_target_type => search.results.first.type.camelize,
              :link_target_id => search.results.first.id
            )
            "<a href=\"/#{search.results.first.type.pluralize}/#{search.results.first.id}-#{search.results.first.handle}\">#{$5}</a>"
          else
            ref = source.references.create!(
              :link_text => $5
            )
            "<a class=\"missing\" href=\"/references/#{ref.id}\">#{$5}<span class=\"icon-remove-circle\"></span></a>"
          end
        # else use the resource, ending in page in case there's a typo
        elsif $4.blank?
          if $2 == 'user'
            target = 'User'
            results = User.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'unit'
            target = 'Unit'
            results = Unit.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'language'
            target = 'Language'
            results = Language.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'photo'
            target = 'Photo'
            results = Photo.where("UPPER(title) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'region'
            target = 'Region'
            results = Region.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'sector'
            target = 'Sector'
            results = Sector.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          elsif $2 == 'work_zone'
            target = 'WorkZone'
            results = WorkZone.where("UPPER(name) LIKE UPPER(?)", "%#{$5}%")
          else
            target = 'Page'
            results = Page.where("UPPER(title) LIKE UPPER(?)", "%#{$5}%")
          end
            
          ref = source.references.create!(
            :link_text => $5,
            :link_target_type => target,
            :link_target_id => (results.any? ? results.first.id : nil),
            :target_count => results.count
          )

          # if there are no results, set the missing link
          if results.count < 1
            "<a class=\"missing\" href=\"/references/#{ref.id}\">#{$5}<span class=\"icon-remove-circle\"></span></a>"
          # if there are more than 1 result, link to disambiguation
          elsif results.count > 1
            "<a class=\"disambiguation\" href=\"/references/#{ref.id}\">#{$5}<span class=\"icon-random\"></span></a>"
          # if there is only one result, link there
          else
            "<a href=\"/#{target.underscore.pluralize}/#{results.first.to_param}\">#{$5}</a>"
          end
        elsif $4 == 'embed'
          resource = $2
          text = $5
          params = []
          $7.scan(/([a-z]+):([a-z0-9]+)/) do |match2|
            # $1 = paramater
            # $2 = value
            case $1
            when 'float'
              params << "wiki-float-#{$2}"
            end
          end
          if resource == 'photo'
            target = 'Photo'
            results = Photo.where("UPPER(title) LIKE UPPER(?)", "%#{text}%")
            ref = source.references.create!(
              :link_text => text,
              :link_target_type => target,
              :link_target_id => (results.any? ? results.first.id : nil),
              :target_count => results.count
            )
            puts results.inspect
            if results.count < 1
              "<a href=\"\" title=\"#{text}\" class=\"wiki-embedded #{params.join(' ')}\"><img class=\"\" src=\"#{PhotoUploader.new.golden374.default_url}\"/></a>"
            elsif results.count > 1
              "<a href=\"\" title=\"#{text}\" class=\"wiki-embedded #{params.join(' ')}\"><img class=\"\" src=\"#{results.first.photo.golden374.url}\"/></a>"
            else
              "<a href=\"\" title=\"#{text}\" class=\"wiki-embedded #{params.join(' ')}\"><img class=\"\" src=\"#{results.first.photo.golden374.url}\"/></a>"
            end
          end
        end
      else
        source.references.create!(
          :link_text => $5,
          :target_count => 1
        )
        "<a href=\"#{$5}\">#{$5}</a>"
      end
    end
  end

  def is_valid?
    target_count == 1 && !new_record?
  end

end

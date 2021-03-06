class Language < ActiveRecord::Base
  attr_accessible :code, :description, :name
  
  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'name'
    indexes :code
    indexes :description
  end


  validates :code, :length => { :in => 2..7 }, :uniqueness => { :case_sensitive => false }
  validates :name, :length => { :maximum => 255 }, :presence => true, :uniqueness => { :case_sensitive => false }

  has_many :case_studies, :dependent => :nullify
  has_many :documents, :dependent => :nullify
  has_many :links, :dependent => :nullify
  has_many :pages

  before_validation :do_before_validation
  before_destroy :do_before_destroy

  default_scope :order => 'name ASC'

  private

    def do_before_validation
      self.code = code.upcase
    end

    def do_before_destroy
      pages.each { |page| page.update_attribute(:language_id, 1) }
    end

end

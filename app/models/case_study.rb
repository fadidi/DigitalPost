class CaseStudy < ActiveRecord::Base
  attr_accessible :approach, :challenges, :context, :html, :language_id, :lessons, :recommendations, :results, :summary, :title

  # elasticsearch indexing
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index_name ELASTICSEARCH_INDEX
  mapping do
    indexes :handle, :as => 'title'
    indexes :html
    indexes :language, :as => proc { |cs| cs.language.name }
  end

  validates :approach, :challenges, :context, :lessons, :recommendations, :results, :summary, :presence => true
  validates :language_id, :numericality => {:is_integer => true}
  validates :title, :length => {:minimum => 8, :maximum => 255}, :uniqueness => {:case_sensitive => false}


  belongs_to :language

  private

    before_save do |case_study|
      temp = ''
      {
        'Summary' => summary,
        'Context' => context, 
        'Approach' => approach,
        'Challenges' => challenges,
        'Results' => results,
        'Lessons Learned' => lessons,
        'Recommendations' => recommendations
      }.each do |key,val|
        temp += "<h3>#{key}</h3>"
        temp += val
      end
      case_study.html = Markdown.render(temp)
    end
end

class Staff < ActiveRecord::Base
  attr_accessible :job_description_html, :job_description_markdown, :location, :user_id

  belongs_to :user

  validates :user_id, :presence => true, :numericality => { :is_integer => true }

  before_save :do_before_save

  def to_param
    "#{user.id}-#{user.name.parameterize}"
  end

  private

    def do_before_save
      self.job_description_html = Markdown.render(job_description_markdown)
    end
end

class Stack < ActiveRecord::Base
  attr_accessible :library_id, :stackable_id, :stackable_type, :user_id

  validates :library_id, :stackable_id, :user_id,
  	:numericality => { :is_integer => true }
  validates :stackable_type,
  	:length => { :maximum => 255 },
  	:presence => true

  belongs_to :library
  belongs_to :stackable, :polymorphic => true
  belongs_to :user
end

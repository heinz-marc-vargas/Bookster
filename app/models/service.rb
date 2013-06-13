# encoding: utf-8
class Service < ActiveRecord::Base
  has_and_belongs_to_many :staff
  belongs_to :company
  belongs_to :branch
  has_many :events
  
  validates :name, :length => { :within => 1..50 }
  validates :description, :length => { :within => 1..300 }
  validates_numericality_of :duration, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :charge, :message => "must be a valid amount."

  scope :deleted, lambda {|deleted| {:conditions => ["services.deleted = ?", deleted] }}
  scope :without_deleted, :conditions => {:deleted => 0}

  after_create :set_sequence_no
  
  def service_summary
    name + " (" + duration.to_s + " minutes)"
  end
  
private

  def set_sequence_no
    maxno = Service.where("branch_id = ?", self.branch_id).maximum("sequence_no") || 1
    self.update_attribute(:sequence_no, maxno.to_i + 1)
  end
    
end

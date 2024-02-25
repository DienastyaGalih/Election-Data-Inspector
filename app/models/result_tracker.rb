class ResultTracker < ApplicationRecord
  belongs_to :result
  enum status: { added: 'added', modified: 'modified', removed: 'removed' }
end

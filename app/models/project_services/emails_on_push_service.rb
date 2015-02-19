# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean          default(FALSE), not null
#  properties :text
#  template   :boolean          default(FALSE)
#  push_events           :boolean
#  issues_events         :boolean
#  merge_requests_events :boolean
#  tag_push_events       :boolean
#

class EmailsOnPushService < Service
  prop_accessor :recipients
  validates :recipients, presence: true, if: :activated?

  def title
    'Emails on push'
  end

  def description
    'Email the commits and diff of each push to a list of recipients.'
  end

  def to_param
    'emails_on_push'
  end

  def execute(push_data)
    object_kind = push_data[:object_kind]
    return unless object_kind == "push"

    EmailsOnPushWorker.perform_async(project_id, recipients, push_data)
  end

  def fields
    [
      { type: 'textarea', name: 'recipients', placeholder: 'Emails separated by whitespace' },
    ]
  end
end

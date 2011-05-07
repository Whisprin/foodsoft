require 'test_helper'

class WorkgroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end



# == Schema Information
#
# Table name: groups
#
#  id                  :integer         not null, primary key
#  type                :string(255)     default(""), not null
#  name                :string(255)     default(""), not null
#  description         :string(255)
#  account_balance     :decimal(, )     default(0.0), not null
#  account_updated     :datetime
#  created_on          :datetime        not null
#  role_admin          :boolean         default(FALSE), not null
#  role_suppliers      :boolean         default(FALSE), not null
#  role_article_meta   :boolean         default(FALSE), not null
#  role_finance        :boolean         default(FALSE), not null
#  role_orders         :boolean         default(FALSE), not null
#  weekly_task         :boolean         default(FALSE)
#  weekday             :integer
#  task_name           :string(255)
#  task_description    :string(255)
#  task_required_users :integer         default(1)
#  deleted_at          :datetime
#  contact_person      :string(255)
#  contact_phone       :string(255)
#  contact_address     :string(255)
#  stats               :text
#  task_duration       :integer         default(1)
#


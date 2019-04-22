require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user)
  }
  let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }

  scenario "user toggles a task", js: true do
    sign_in user 

    go_to_project "RSpec tutorial"

    complete_task "Finish RSpec tutorial"

    expect_complete_task "Finish RSpec tutorial"

  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def expect_complete_task(name) 
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
  end
end

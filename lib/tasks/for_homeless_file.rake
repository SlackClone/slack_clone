namespace :attachfile do

  desc "Assign workspace_id to homeless files"

  task assign_workspace_id: :environment do
    files = Attachfile.where(workspace_id: nil)
    workspace = Workspace.find_by(name: "How you like that")
    files.each do |file|
      file.update(workspace_id: workspace.id)
    end

  end
end
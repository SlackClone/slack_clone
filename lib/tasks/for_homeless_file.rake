namespace :attachfile do

  desc "Assign workspace_id to homeless files"

  task :assign_workspace_id, [:date] => [:environment] do |t, args|
    # 把換AWS帳號前的檔案記錄刪掉
    Attachfile.where("created_at < ?", args[:date]).destroy_all
    # 找到無家可歸的檔案
    files = Attachfile.where(workspace_id: nil)
    # 把它併到How you like that 或是 最後一個workspace
    workspace = Workspace.find_by(name: "How you like that") || Workspace.last
    files.each do |file|
      file.update(workspace_id: workspace.id)
    end
    puts "將#{args[:date]}以前的檔案刪除"
    puts "無家可歸的檔案已經被加入Workspace:#{workspace.name} by Hank"
  end
end
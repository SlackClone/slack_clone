namespace :example do

  desc "Initialize SlaDock demo status"

  task demo_initial: :environment do
    # 找到同樣 workspace 名字的，刪除所有相關 ex. workspace, channel, message, directmsg, third-table

    # 找到既有的 workspace 並刪除 channel, message, directmsg, third-table (有 dependent destroy 會自動刪除)
    Workspace.find_by(name: "AAA公司").try(:destroy)

    # 找到既有的 user 並刪除
    User.where(nickname: ["老闆", "主管", "新人", "同事1", "同事2"]).try(:destroy)

    # 建立需要的 workspace
    # 建立 User 五名「老闆」、「主管」、「新人」、「同事1」、「同事2」
    # workspace 下建立 channel: HEAD, 加入「老闆」與「主管」, 訊息加入「專案事項」
    # 加入 Catbot 使用者，並加入 channel GitHub_msg
    # 每個使用者加入 general

    
    puts "#{User.find(1).email}"
  end
end